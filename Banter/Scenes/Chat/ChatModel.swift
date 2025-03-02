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

struct MockMessageRepository: MessageRepository {
    func getMessages(id: String) -> [Message] {
        [
            Message(sender: Sender(senderId: "selfAdress", displayName: "Self"), messageId: UUID().uuidString, sentDate: Date().addingTimeInterval(-1), kind: .text("Lorem ipsum dolor sit amet, consectetur adipisicing elit")),
            
            Message(sender: Sender(senderId: "2", displayName: "Other"), messageId: UUID().uuidString, sentDate: Date().addingTimeInterval(-3600), kind: .text("Lorem ipsum dolor sit amet, consectetur ")),
            
            Message(sender: Sender(senderId: "selfAdress", displayName: "Self"), messageId: UUID().uuidString, sentDate: Date().addingTimeInterval(-7200), kind: .text("Lorem ipsum dolor t")),
            
            Message(sender: Sender(senderId: "2", displayName: "Other"), messageId: UUID().uuidString, sentDate: Date().addingTimeInterval(-8000), kind: .text("Lorem ipsum dolor sit amet")),
        ]
    }
    
}

@Observable
final class ChatModel {
    private let mockData: MessageRepository = MockMessageRepository()
    var chatAddress: String
    var selfSender: Sender
    var messages: [Message] = []
    var isSubscribed = false
    

  init(chatAddress: String) {
    @Shared(.userAdressKeyHex) var userAdressKeyHex
    self.chatAddress = chatAddress
      
    ///`self.selfSender = Sender(senderId: userAdressKeyHex, displayName: "Self")`
      ///этот код с установкой адреса в качестве id отправителя
      ///но пока оставил мок данные, потом просто надо будет раскоментить
      ///и убрать нижнюю строку
    self.selfSender = Sender(senderId: "selfAdress", displayName: "Self")
  }

    func viewAppeared() {
        Task{
            self.messages = try await mockData.getMessages(id: chatAddress)
        }
        
  }
    
    func sendMessageTapped(message: Message) {
        self.messages.append(message)
        /// тут будет дальнейшая отправка в блок
    }
}
