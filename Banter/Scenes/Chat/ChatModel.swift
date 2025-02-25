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
  var isSubscribed = false

  init(chatAddress: String) {
    self.chatAddress = chatAddress
  }

  func viewAppeared() {
    guard !isSubscribed else { return }
    isSubscribed = true
    getMessages(chatAddress: chatAddress) { [weak self] message in
      DispatchQueue.main.async {
        self?.messages.insert(message, at: 0)
      }
    }
  }

  func sendMessageTapped() {
    sendMessage(address: chatAddress, message: newMessage)
    newMessage = ""
  }
}
