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

@Observable
final class ChatListModel {
  @ObservationIgnored @Shared(.walletKeyHex) var walletKeyHex

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

  func viewAppeared() {
    guard !isSubscribed else { return }
    isSubscribed = true
    getChats { [weak self] newChat in
      DispatchQueue.main.async {
        let chat = Chat(address: newChat)
        self?.chats.append(chat)
      }
    }
  }

  func createNewChat() {
    createChat(recipient: newChatAddress)
    newChatAddress = ""
  }
}
