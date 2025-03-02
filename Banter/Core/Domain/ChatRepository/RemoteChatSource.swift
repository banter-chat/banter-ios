// RemoteChatSource.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 2/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

/// Remote data source for retrieving chat data from backend services.
///
/// - Note: This is typically used internally by a `ChatRepository` implementation.
///   Most app code should interact with the repository instead.
protocol RemoteChatSource {
  /// Observes all chats from the remote service, emitting updates when changes occur.
  ///
  /// - Returns: A stream of chat arrays representing the current state on the server.
  /// - Important: The stream may disconnect if network conditions change. The implementation
  ///   should handle reconnection internally.
  func observeChats() -> AsyncStream<[Chat]>
}
