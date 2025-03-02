// LiveChatMessageRepository.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Web3

extension LiveChatMessageRepository: ChatMessageRepository {
  func getMessages(before _: Date? = nil, limit _: Int) async throws -> [ChatMessage] {
    try await remoteSource.getAllMessages()
  }

  func observeMessageUpdates() -> AsyncStream<ChatMessageUpdate> {
    remoteSource.observeUpdates()
  }
}

final class LiveChatMessageRepository {
  private let remoteSource: RemoteChatMessageSource

  /// Creates a new repository instance for the specified chat contract.
  ///
  /// - Parameters:
  ///   - remoteSource: `RemoteChatMessageSource` implementation that will be used to retrieve the data.
  init(remoteSource: RemoteChatMessageSource) {
    self.remoteSource = remoteSource
  }
}
