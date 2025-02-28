// ChatRepository.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 26/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation

protocol ChatRepository {
  func observeChats() -> AsyncStream<[Chat]>
}

protocol RemoteChatDataSource {
  func observeChats() -> AsyncStream<[Chat]>
}

final class LiveChatRepository: ChatRepository {
  let remoteDataSource: RemoteChatDataSource

  private var sourceStream: AsyncStream<[Chat]>?
  private var subscribers: [UUID: AsyncStream<[Chat]>.Continuation] = [:]
  private var observeTask: Task<Void, Never>?
  private var latestValue: [Chat]?

  init(remoteDataSource: RemoteChatDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  func observeChats() -> AsyncStream<[Chat]> {
    startObservingSourceStreamIfNeeded()
    return createSubscriberStream()
  }

  private func startObservingSourceStreamIfNeeded() {
    guard observeTask == nil else { return }

    observeTask = Task {
      for await chats in remoteDataSource.observeChats() {
        latestValue = chats

        for (_, continuation) in subscribers {
          continuation.yield(chats)
        }
      }

      for (_, continuation) in subscribers {
        continuation.finish()
      }

      subscribers.removeAll()
      observeTask = nil
    }
  }

  private func createSubscriberStream() -> AsyncStream<[Chat]> {
    return AsyncStream { continuation in
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
