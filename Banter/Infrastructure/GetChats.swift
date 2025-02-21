// GetChats.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3
import Web3ContractABI

func getChats(onNewChat: @escaping (String) -> Void) {
  let web3 = try! Web3(wsUrl: "wss://virtual.sepolia.rpc.tenderly.co/06ab9e05-c020-413c-b832-5e7f0cb123c3")

  let contractHex = "0xa4f241137a82E03f69c866436483B17Ed50E5564"
  let contractAddress = try! EthereumAddress(hex: contractHex, eip55: true)

  web3.eth.getLogs(addresses: [contractAddress],
                   topics: nil,
                   fromBlock: .earliest,
                   toBlock: .latest) {
    for log in $0.result! {
      let event = try! ABI.decodeLog(event: ChatListContract.NewChat, from: log)
      let chatName = event["name"] as! String
      onNewChat(chatName)
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
