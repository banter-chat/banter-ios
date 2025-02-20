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
  var chats: [Chat] = []

  var task: URLSessionTask?

  func viewAppeared() {
    getChats { newChat in
      DispatchQueue.main.async {
        let chat = Chat(address: newChat)
        self.chats.append(chat)
      }
    }
  }
}

import Web3
import Web3ContractABI

func getChats(onNewChat: @escaping (String) -> Void) {
  let web3 = try! Web3(wsUrl: "wss://virtual.sepolia.rpc.tenderly.co/06ab9e05-c020-413c-b832-5e7f0cb123c3")

  let contractHex = "0x4754381b7fB7ebD1CBb263A197880492E0cb25e6"
  let contractAddress = try! EthereumAddress(hex: contractHex, eip55: true)

  let contract = web3.eth.Contract(type: ChatListContract.self, address: contractAddress)

  contract.getChats().call { response, _ in
    let chatsArray = response!["availableChats"]! as! [String]
    for chat in chatsArray {
      onNewChat(chat)
    }
  }

  try! web3.eth.subscribeToLogs(addresses: [contractAddress]) { _ in
    print("subscribed")
  } onEvent: { resp in
    let log = resp.result!

    let event = try! ABI.decodeLog(event: ChatListContract.NewChat, from: log)
    let chatName = event["name"] as! String
    onNewChat(chatName)
  }
}
