// ChatModel.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

@Observable
final class ChatModel {
  var chatAddress: String
  var messages: [String] = []
  var newMessage = ""

  let repo: MessageRepository = MockMessageRepository()

  init(chatAddress: String) {
    self.chatAddress = chatAddress
  }

  func viewAppeared() async {
    let chatMessages = try! await repo.getMessages(before: nil, limit: 10)
    self.messages = chatMessages.map(\.content)

    for await updates in repo.observeMessageUpdates() {
      switch updates {
      case .added(let message):
        messages.append(message.content)
      }
    }
  }

  func sendMessageTapped() {
    sendMessage(address: chatAddress, message: newMessage)
    newMessage = ""
  }
}
