// ChatModel.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import MessageKit
import Sharing
import SwiftUI

protocol ChatModelProtocol: AnyObject {
  var messages: [Message] { get }
  func viewAppeared()
  func sendMessageTapped(message: Message)
  var selfSender: Sender { get }
}

final class ChatModel: ChatModelProtocol {
  var chatAddress: String
  var selfSender: Sender
  var messages: [Message] = [] {
    willSet {
      view?.updateChat()
    }
  }

  var isSubscribed = false
  let repo: ChatMessageRepository

  weak var view: ChatViewContentProtocol?

init(senderId: String ,chatAddress: String, view: ChatViewContentProtocol, repo: ChatMessageRepository) {
    self.chatAddress = chatAddress
    self.view = view
    self.repo = repo
    self.selfSender = Sender(senderId: senderId, displayName: "Self")
  }

  func viewAppeared() {
    Task {
        let allMessage = try await self.repo.getMessages(before: nil, limit: 10)
      let messages = allMessage.map {
        self.covertMessage(from: $0)
      }

        if !allMessage.isEmpty {
            self.messages = messages.sorted { $0.sentDate < $1.sentDate }
        } else {
            self.messages = messages
        }
      

      for await updates in repo.observeMessageUpdates() {
        switch updates {
        case let .added(message):
          self.messages.append(covertMessage(from: message))
        }
      }
    }
  }

  private func covertMessage(from message: ChatMessage) -> Message {
      Message(sender: message.senderId == selfSender.senderId.lowercased() ? selfSender : Sender(senderId: message.senderId, displayName: "Other"), messageId: message.id, sentDate: message.timestamp, kind: .text(message.content))
  }

  func sendMessageTapped(message: Message) {
    guard case let .text(content) = message.kind else { return }
    sendMessage(address: chatAddress, message: content)
  }
}
