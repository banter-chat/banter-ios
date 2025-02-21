// GetChats.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Web3
import Web3ContractABI
import Sharing

func getChats(onNewChat: @escaping (String) -> Void) {
  @Shared(.rpcWSURL) var rpcWSURL
  @Shared(.chatListAddress) var chatListAddress

  let web3 = try! Web3(wsUrl: rpcWSURL)

  let contractAddress = try! EthereumAddress(hex: chatListAddress, eip55: false)

  web3.eth.getLogs(addresses: [contractAddress],
                   topics: nil,
                   fromBlock: .earliest,
                   toBlock: .latest) {
    for log in $0.result! {
      let event = try! ABI.decodeLog(event: ChatListContract.ChatCreated, from: log)
      let chat = event["chatContract"] as! EthereumAddress
      onNewChat(chat.hex(eip55: false))
    }
  }

  try! web3.eth.subscribeToLogs(addresses: [contractAddress]) { _ in
    print("subscribed")
  } onEvent: { resp in
    let log = resp.result!

    let event = try! ABI.decodeLog(event: ChatListContract.ChatCreated, from: log)
    let chat = event["chatContract"] as! EthereumAddress
    onNewChat(chat.hex(eip55: true))
  }
}
