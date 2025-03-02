// MockMessageRepository.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 26/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation

/// A mock implementation of the `MessageRepository` protocol for use in SwiftUI previews,
/// view development, and testing.
///
/// This implementation provides:
/// - A configurable set of mock messages
/// - Pagination support mimicking a real repository
/// - A simulated stream of new messages at configurable intervals
///
/// ## Usage Example
///
/// ```swift
/// // For SwiftUI previews or testing
/// let mockRepository = MockMessageRepository(
///     mockMessages: MockMessageRepository.defaultMockMessages,
///     newMessageInterval: 3.0  // New message every 3 seconds
/// )
///
/// // Use in a view preview
/// struct ChatView_Previews: PreviewProvider {
///     static var previews: some View {
///         ChatView(repository: mockRepository)
///     }
/// }
/// ```
final class MockMessageRepository: MessageRepository {
  // MARK: - Properties

  /// Collection of mock messages for testing
  private var messages: [ChatMessage]

  /// Timer for generating new messages
  private var timer: Timer?

  /// Continuation for the message update stream
  private var streamContinuation: AsyncStream<MessageUpdate>.Continuation?

  /// Random names to use for generated senders
  private let senderNames = [
    "Alice", "Bob", "Charlie", "Diana", "Evan",
    "Fiona", "George", "Hannah", "Ian", "Julia",
  ]

  /// Interval at which new messages should be generated (in seconds)
  private let newMessageInterval: TimeInterval

  /// Controls whether automatic message generation is enabled
  private let automaticMessageGeneration: Bool

  // MARK: - Initialization

  /// Creates a new mock message repository with the specified messages and configuration.
  ///
  /// - Parameters:
  ///   - mockMessages: Initial messages to include in the repository
  ///   - newMessageInterval: Time interval (in seconds) between automatic new message generation
  ///   - automaticMessageGeneration: Whether to automatically generate new messages
  init(
    mockMessages: [ChatMessage] = [],
    newMessageInterval: TimeInterval = 5.0,
    automaticMessageGeneration: Bool = true
  ) {
    self.messages = mockMessages.sorted(by: { $0.timestamp > $1.timestamp })
    self.newMessageInterval = newMessageInterval
    self.automaticMessageGeneration = automaticMessageGeneration

    if automaticMessageGeneration {
      setupAutomaticMessageGeneration()
    }
  }

  deinit {
    timer?.invalidate()
    streamContinuation?.finish()
  }

  // MARK: - MessageRepository Implementation

  func getMessages(before: Date? = nil, limit: Int) async throws -> [ChatMessage] {
    // Simulate network delay
    try? await Task.sleep(nanoseconds: UInt64(0.2 * 1_000_000_000))

    if let before = before {
      return
        messages
        .filter { $0.timestamp < before }
        .prefix(limit)
        .sorted(by: { $0.timestamp > $1.timestamp })
    } else {
      return Array(messages.prefix(limit))
    }
  }

  func observeMessageUpdates() -> AsyncStream<MessageUpdate> {
    return AsyncStream<MessageUpdate> { continuation in
      self.streamContinuation = continuation

      // Allow for cancellation
      continuation.onTermination = { @Sendable _ in
        self.streamContinuation = nil
      }
    }
  }

  // MARK: - Helper Methods

  /// Sets up a timer to automatically generate new messages at the specified interval.
  private func setupAutomaticMessageGeneration() {
    timer = Timer.scheduledTimer(withTimeInterval: newMessageInterval, repeats: true) {
      [weak self] _ in
      self?.addRandomMessage()
    }
  }

  /// Adds a random message to the repository and notifies observers.
  @discardableResult
  public func addRandomMessage() -> ChatMessage {
    let message = generateRandomMessage()
    addMessage(message)
    return message
  }

  /// Adds a specific message to the repository and notifies observers.
  ///
  /// - Parameter message: The message to add
  public func addMessage(_ message: ChatMessage) {
    messages.insert(message, at: 0)
    streamContinuation?.yield(.added(message: message))
  }

  /// Generates a random message for testing purposes.
  ///
  /// - Returns: A randomly generated `ChatMessage`
  private func generateRandomMessage() -> ChatMessage {
    let id = UUID().uuidString
    let senderId = String(abs(Int.random(in: 1...100)))
    let senderNameIndex = Int.random(in: 0..<senderNames.count)

    let messageTemplates = [
      "Hey, how's it going?",
      "Did you see the news today?",
      "I'm working on that project we discussed.",
      "Can we meet later?",
      "Just checking in!",
      "What do you think about the new design?",
      "I'll send you the details soon.",
      "Let me know when you're available.",
      "Thanks for your help yesterday!",
      "Have you tried the new coffee place downtown?",
    ]

    let messageIndex = Int.random(in: 0..<messageTemplates.count)
    let content = messageTemplates[messageIndex]

    return ChatMessage(
      id: id,
      senderId: senderId,
      content: "[\(senderNames[senderNameIndex])]: \(content)",
      timestamp: Date()
    )
  }

  // MARK: - Static Helper Methods

  /// Provides a default set of mock messages for testing.
  ///
  /// - Returns: An array of mock `ChatMessage` objects
  public static var defaultMockMessages: [ChatMessage] {
    // Generate timestamps going backward from now
    let now = Date()
    let timestamps: [Date] = (0..<15).map { index in
      now.addingTimeInterval(-Double(index * 300))  // 5 minutes apart
    }

    return [
      ChatMessage(
        id: "1",
        senderId: "user1",
        content: "[Alice]: Hey everyone! Welcome to the chat.",
        timestamp: timestamps[0]
      ),
      ChatMessage(
        id: "2",
        senderId: "user2",
        content: "[Bob]: Thanks Alice! Excited to be here.",
        timestamp: timestamps[1]
      ),
      ChatMessage(
        id: "3",
        senderId: "user3",
        content: "[Charlie]: Has anyone started working on the new project yet?",
        timestamp: timestamps[2]
      ),
      ChatMessage(
        id: "4",
        senderId: "user1",
        content: "[Alice]: I've just finished setting up the repository. I'll share access soon.",
        timestamp: timestamps[3]
      ),
      ChatMessage(
        id: "5",
        senderId: "user4",
        content: "[Diana]: Looking forward to collaborating with all of you!",
        timestamp: timestamps[4]
      ),
      ChatMessage(
        id: "6",
        senderId: "user2",
        content: "[Bob]: @Charlie I've started working on the UI design. Want to sync up later?",
        timestamp: timestamps[5]
      ),
      ChatMessage(
        id: "7",
        senderId: "user3",
        content: "[Charlie]: @Bob Sure thing! How about 3pm?",
        timestamp: timestamps[6]
      ),
      ChatMessage(
        id: "8",
        senderId: "user5",
        content: "[Evan]: Just joined the team. Can someone catch me up?",
        timestamp: timestamps[7]
      ),
      ChatMessage(
        id: "9",
        senderId: "user1",
        content: "[Alice]: @Evan check your email, I've sent you the project brief.",
        timestamp: timestamps[8]
      ),
      ChatMessage(
        id: "10",
        senderId: "user4",
        content: "[Diana]: The deadline is next Friday, right?",
        timestamp: timestamps[9]
      ),
      ChatMessage(
        id: "11",
        senderId: "user1",
        content: "[Alice]: @Diana Yes, but we should try to finish by Wednesday for testing.",
        timestamp: timestamps[10]
      ),
      ChatMessage(
        id: "12",
        senderId: "user6",
        content: "[Fiona]: Sorry I'm late to the conversation. Had a meeting that ran over.",
        timestamp: timestamps[11]
      ),
      ChatMessage(
        id: "13",
        senderId: "user2",
        content: "[Bob]: No worries, Fiona. We're just getting started.",
        timestamp: timestamps[12]
      ),
      ChatMessage(
        id: "14",
        senderId: "user7",
        content: "[George]: Does anyone have the login details for the staging server?",
        timestamp: timestamps[13]
      ),
      ChatMessage(
        id: "15",
        senderId: "user1",
        content: "[Alice]: @George I'll send them to you in a direct message.",
        timestamp: timestamps[14]
      ),
    ]
  }
}

// MARK: - Preview Provider Helper

extension MockMessageRepository {
  /// Creates a preconfigured mock repository suitable for SwiftUI previews.
  ///
  /// - Parameters:
  ///   - messageInterval: Time interval (in seconds) between automatic new message generation
  ///   - initialMessages: Optional initial set of messages
  ///
  /// - Returns: A configured `MockMessageRepository` ready for use in previews
  static func previewRepository(
    messageInterval: TimeInterval = 3.0,
    initialMessages: [ChatMessage]? = nil
  ) -> MockMessageRepository {
    return MockMessageRepository(
      mockMessages: initialMessages ?? defaultMockMessages,
      newMessageInterval: messageInterval
    )
  }
}
