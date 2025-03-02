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

extension LiveChatRepository: ChatRepository {
  func observeChats() -> AsyncStream<[Chat]> {
    createSubscriberStream()
  }
}

final class LiveChatRepository {
  @Shared(.userSettings) private var settings

  private let remoteSourceFactory: RemoteChatSourceFactory
  private var remoteSource: RemoteChatSource?
  private var settingsObservation: AnyCancellable?

  private var subscribers: [UUID: AsyncStream<[Chat]>.Continuation] = [:]
  private var sourceTask: Task<Void, Never>?
  private var latestValue: [Chat]?

  init(remoteSourceFactory: RemoteChatSourceFactory) {
    self.remoteSourceFactory = remoteSourceFactory
    observeSettings()
  }

  private func observeSettings() {
    settingsObservation = $settings.publisher
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] in self?.updateDataSource(with: $0) }
  }

  private func updateDataSource(with settings: UserSettings) {
    sourceTask?.cancel()
    latestValue = nil

    remoteSource = try? remoteSourceFactory.makeDataSource(with: settings)

    if !subscribers.isEmpty {
      startObservingSource()
    }
  }

  private func startObservingSource() {
    guard let remoteSource, sourceTask == nil else { return }

    sourceTask = Task {
      defer { sourceTask = nil }

      for await chats in remoteSource.observeChats() {
        latestValue = chats

        for continuation in subscribers.values {
          continuation.yield(chats)
        }
      }

      if !Task.isCancelled {
        for continuation in subscribers.values {
          continuation.finish()
        }

        subscribers.removeAll()
      }
    }
  }

  private func createSubscriberStream() -> AsyncStream<[Chat]> {
    startObservingSource()

    let streamId = UUID()

    let (stream, continuation) = AsyncStream<[Chat]>.makeStream()
    subscribers[streamId] = continuation

    if let latestValue {
      continuation.yield(latestValue)
    }

    continuation.onTermination = { [weak self] _ in
      self?.subscribers.removeValue(forKey: streamId)
      self?.cancelSourceIfNotNeeded()
    }

    return stream
  }

  private func cancelSourceIfNotNeeded() {
    if subscribers.isEmpty {
      sourceTask?.cancel()
    }
  }
}
