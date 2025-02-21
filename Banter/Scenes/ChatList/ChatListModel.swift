// ChatListModel.swift is a part of Web3Chat project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 19/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

@Observable
final class ChatListModel {
  private let rpcWSURL: String
  private let contractAddress: String

  var chats: [Chat] = []
  var isSubscribed = false

  init(rpcWSURL: String, contractAddress: String) {
    self.rpcWSURL = rpcWSURL
    self.contractAddress = contractAddress
  }

  func viewAppeared() {
    guard !isSubscribed else { return }
    isSubscribed = true
    getChats(
      rpcWSURL: rpcWSURL, contractAddress: contractAddress
    ) { [weak self] newChat in
      DispatchQueue.main.async {
        let chat = Chat(address: newChat)
        self?.chats.append(chat)
      }
    }
  }
}
