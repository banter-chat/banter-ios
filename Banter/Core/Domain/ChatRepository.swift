// ChatRepository.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 26/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Combine
import Foundation
import Sharing

protocol ChatRepository {
  func observeChats() -> AsyncStream<[Chat]>
}

protocol RemoteChatDataSource {
  func observeChats() -> AsyncStream<[Chat]>
}

protocol RemoteChatDataSourceFactory {
  func makeDataSource(with: UserSettings) throws -> RemoteChatDataSource
}

final class LiveChatRepository: ChatRepository {
  @Shared(.userSettings) var settings

  private let dataSourceFactory: RemoteChatDataSourceFactory
  private var remoteDataSource: RemoteChatDataSource?
  private var sourceStream: AsyncStream<[Chat]>?
  private var subscribers: [UUID: AsyncStream<[Chat]>.Continuation] = [:]
  private var observeTask: Task<Void, Never>?
  private var latestValue: [Chat]?
  private var settingsObservation: AnyCancellable?

  init(dataSourceFactory: RemoteChatDataSourceFactory) {
    self.dataSourceFactory = dataSourceFactory
    self.remoteDataSource = try? dataSourceFactory.makeDataSource(with: settings)
    startSettingsObservation()
  }

  func observeChats() -> AsyncStream<[Chat]> {
    startObservingSourceStream()
    return createSubscriberStream()
  }

  private func startSettingsObservation() {
    settingsObservation = $settings.publisher
      .sink { [weak self] in self?.updateSettings($0) }
  }

  private func updateSettings(_ settings: UserSettings) {
    guard let newSource = try? dataSourceFactory.makeDataSource(with: settings) else {
      return
    }

    observeTask?.cancel()
    observeTask = nil

    remoteDataSource = newSource

    if !subscribers.isEmpty {
      startObservingSourceStream()
    }
  }

  private func startObservingSourceStream() {
    guard let remoteDataSource, observeTask == nil else { return }

    observeTask = Task {
      for await chats in remoteDataSource.observeChats() {
        latestValue = chats

        for (_, continuation) in subscribers {
          continuation.yield(chats)
        }
      }

      if !Task.isCancelled {
        for (_, continuation) in subscribers {
          continuation.finish()
        }
        subscribers.removeAll()
      }

      observeTask = nil
    }
  }

  private func createSubscriberStream() -> AsyncStream<[Chat]> {
    AsyncStream { continuation in
      let streamId = UUID()
      subscribers[streamId] = continuation

      if let latestValue {
        continuation.yield(latestValue)
      }

      continuation.onTermination = { [weak self] _ in
        self?.subscribers.removeValue(forKey: streamId)
        self?.checkIfSourceStreamStillNeeded()
      }
    }
  }

  private func checkIfSourceStreamStillNeeded() {
    if subscribers.isEmpty {
      observeTask?.cancel()
      observeTask = nil
    }
  }
}
