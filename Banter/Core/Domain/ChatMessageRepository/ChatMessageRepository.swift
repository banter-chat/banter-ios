// ChatMessageRepository.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 26/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation

/// A repository interface for retrieving chat messages.
///
/// The ChatMessageRepository provides access to chat message history using timestamp-based pagination.
///
/// ## Usage Example
///
/// ```swift
/// let repository: ChatMessageRepository = /* repository implementation */
///
/// // Get the most recent messages
/// let recentMessages = try await repository.getMessages(limit: 30)
///
/// // Get older messages based on the oldest message timestamp
/// if let oldestTimestamp = recentMessages.map(\.timestamp).min() {
///     let olderMessages = try await repository.getMessages(
///         before: oldestTimestamp,
///         limit: 30
///     )
/// }
/// ```
protocol ChatMessageRepository {
  /// Retrieves chat messages with pagination support.
  ///
  /// This method fetches a batch of messages ordered by timestamp. When `before` is provided,
  /// it retrieves messages that were sent before that timestamp. When `before` is nil, it retrieves
  /// the most recent messages.
  ///
  /// - Parameters:
  ///   - before: An optional timestamp to retrieve messages sent before this date.
  ///     When nil, retrieves the most recent messages.
  ///   - limit: The maximum number of messages to retrieve. Recommended values are
  ///     between 20-50 for optimal performance.
  ///
  /// - Returns: An array of `ChatMessage` objects ordered by timestamp (newest to oldest).
  ///
  /// - Throws: An error if the retrieval operation fails.
  func getMessages(before: Date?, limit: Int) async throws -> [ChatMessage]

  /// Provides a stream of real-time message updates for this chat.
  ///
  /// This method returns an `AsyncStream` that emits events whenever a message is added to the chat.
  /// The stream continues until it's explicitly cancelled or the associated task is cancelled.
  ///
  /// - Returns: An `AsyncStream` of `ChatMessageUpdate` events. Currently, this includes message additions,
  ///   with support for future update types like edits and deletions.
  ///
  /// ## Example
  ///
  /// ```swift
  /// let repository: ChatMessageRepository = /* repository implementation */
  ///
  /// // Start observing updates
  /// let task = Task {
  ///     for await update in repository.observeMessageUpdates() {
  ///         switch update {
  ///         case .added(let message):
  ///             // Handle the new message
  ///             print("New message received: \(message.content)")
  ///         }
  ///     }
  /// }
  ///
  /// // Later, cancel the observation
  /// task.cancel()
  /// ```
  func observeMessageUpdates() -> AsyncStream<ChatMessageUpdate>
}
