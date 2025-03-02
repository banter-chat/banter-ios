// RemoteChatMessageSource.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 2/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

/// Remote data source for retrieving chat messages data from backend services.
///
/// - Note: This is typically used internally by a `ChatMessageRepository` implementation.
///   Most app code should interact with the repository instead.
protocol RemoteChatMessageSource {
  /// Retrieves chat all messages available on the server
  ///
  /// - Returns: An array of `ChatMessage` objects ordered by timestamp (newest to oldest).
  ///
  /// - Throws: An error if the retrieval operation fails.
  func getAllMessages() async throws -> [ChatMessage]

  /// Observes message updates from the remote service, emitting updates when changes occur.
  ///
  /// - Returns: A stream of message updates data.
  func observeUpdates() -> AsyncStream<ChatMessageUpdate>
}
