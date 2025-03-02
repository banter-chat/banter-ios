// ChatRepository.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 2/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

/// Repository for accessing chat data.
///
/// - Note: This repository provides a reactive stream of chat data that updates
///   automatically when chats change. There's no need to poll or refresh manually.
protocol ChatRepository {
  /// Observes all chats, emitting updates when the chat list changes.
  ///
  /// - Returns: A stream of chat arrays. Each emission contains the complete list of chats.
  /// - Important: Remember to maintain a strong reference to the returned stream.
  ///
  /// Example:
  /// ```swift
  /// // In your view model or controller:
  /// private var chatStream: Task<Void, Never>?
  /// private var chats: [Chat] = []
  ///
  /// func startObservingChats() {
  ///     let stream = repository.observeChats()
  ///     chatStream = Task {
  ///         for await updatedChats in stream {
  ///             self.chats = updatedChats
  ///             await self.updateUI()
  ///         }
  ///     }
  /// }
  ///
  /// func stopObservingChats() {
  ///     chatStream?.cancel()
  ///     chatStream = nil
  /// }
  /// ```
  func observeChats() -> AsyncStream<[Chat]>
}
