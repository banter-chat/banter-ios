// ChatModel.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI
import MessageKit
import Sharing


@Observable
final class ChatModel {
    //private let mockData: MessageRepository = MockMessageRepository()
    var chatAddress: String
    var selfSender: Sender
    var messages: [Message] = []
    var isSubscribed = false
    let mockRepo = MockMessageRepository(mockMessages: [])

  init(chatAddress: String) {
    self.chatAddress = chatAddress
      
    ///`self.selfSender = Sender(senderId: userAdressKeyHex, displayName: "Self")`
      ///этот код с установкой адреса в качестве id отправителя
      ///но пока оставил мок данные, потом просто надо будет раскоментить
      ///и убрать нижнюю строку
    self.selfSender = Sender(senderId: "selfAdress", displayName: "Self")
  }

    func viewAppeared() {
        Task{
            let mockMessage = try await self.mockRepo.getMessages(limit: 10)
            let messages = mockMessage.map {
                return self.covertMessage(from: $0)
            }
            
            self.messages = messages
            
            for await updates in mockRepo.observeMessageUpdates() {
                  switch updates {
                  case .added(let message):
                      self.messages.append(covertMessage(from: message))
                      print(message)
                  }
            }
        }
  }
    private func covertMessage(from message: ChatMessage) -> Message{
        return Message(sender: message.senderId == "selfAdress" ? self.selfSender : Sender(senderId: message.senderId, displayName: "Other"), messageId: message.id, sentDate: message.timestamp, kind: .text(message.content))
    }
    
    func sendMessageTapped(message: Message) {
        self.messages.append(message)
        /// тут будет дальнейшая отправка в блок
    }
}
