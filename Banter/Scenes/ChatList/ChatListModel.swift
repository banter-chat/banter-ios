// ChatListModel.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 19/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Sharing
import SwiftUI
import Web3

struct MockRepo: ChatRepository {
  func getChats() -> [Chat] {
    [
      Chat(id: "1", title: "Chat 1"),
      Chat(id: "2", title: "Chat 2")
    ]
  }
}

struct ChatDisplay {
  var id: String
  var content: String

  init(chat: Chat) {
    self.id = chat.id
    self.content = chat.title ?? ""
  }
}

@Observable
final class ChatListModel {
  @ObservationIgnored @Shared(.walletKeyHex) var walletKeyHex
    private let mock = MockRepo()
  var chats: [Chat] = []
  var isSubscribed = false
  var newChatAddress = ""

  var walletAddress: String? {
    let key = try? EthereumPrivateKey(hexPrivateKey: walletKeyHex)
    return key?.address.hex(eip55: true)
  }

  func copyWalletAddressTapped() {
    UIPasteboard.general.string = walletAddress
  }

    /// Вернул чаты из мок
    /// Получение из блока пока закоментил, потом когда вся логика
    /// будет готова останется ее тут прописать
  func viewAppeared() {
      self.chats = mock.getChats()
//    guard !isSubscribed else { return }
//    isSubscribed = true
//    getChats { [weak self] newChat in
//      DispatchQueue.main.async {
//        let chat = Chat(id: newChat)
//        self?.chats.append(chat)
//      }
//    }
  }

  func createNewChat() {
    createChat(recipient: newChatAddress)
    newChatAddress = ""
  }
}
