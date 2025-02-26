// MessageRepository.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 26/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

protocol MessageRepository {
  func getMessages(id: Chat.ID) async throws -> [ChatMessage]
  // messagesStream(id: Chat.ID) async throws -> AsyncSequence<[ChatMessage]>
}