// ChatMessageUpdate.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

/// Represents types of updates that can occur to messages in a chat.
///
/// This enum defines the various types of message events that can be observed
/// through the `observeMessageUpdates` method.
enum ChatMessageUpdate {
  /// Indicates that a new message was added to the chat.
  ///
  /// - Parameter message: The new message that was added.
  case added(message: ChatMessage)
  // Future expansion:
  // case edited(message: Message)
  // case deleted(messageId: String)
  // case statusChanged(messageId: String, status: MessageStatus)
}
