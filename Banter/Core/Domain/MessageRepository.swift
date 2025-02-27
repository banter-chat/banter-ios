// MessageRepository.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 26/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation

protocol MessageRepository {
  func getMessages(before: Date?, limit: Int) async throws -> [ChatMessage]
}