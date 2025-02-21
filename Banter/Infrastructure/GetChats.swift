// GetChats.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Sharing
import Web3
import Web3ContractABI

func getChats(onNewChat: @escaping (String) -> Void) {
  @Shared(.rpcWSURL) var rpcWSURL
  @Shared(.chatListAddress) var chatListAddress
  @Shared(.walletKeyHex) var walletKeyHex

  guard
    let web3 = try? Web3(wsUrl: rpcWSURL),
    let contractAddress = try? EthereumAddress(hex: chatListAddress, eip55: false),
    let caller = try? EthereumPrivateKey(hexPrivateKey: walletKeyHex).address
  else { return }

  web3.eth.getLogs(addresses: [contractAddress],
                   topics: nil,
                   fromBlock: .earliest,
                   toBlock: .latest) { resp in
    guard let logs = resp.result else { return }
    for log in logs {
      processChatEvent(caller: caller, log: log, onNewChat: onNewChat)
    }
  }

  try! web3.eth.subscribeToLogs(addresses: [contractAddress]) { _ in
    print("subscribed")
  } onEvent: { resp in
    guard let log = resp.result else { return }
    processChatEvent(caller: caller, log: log, onNewChat: onNewChat)
  }
}

func processChatEvent(
  caller: EthereumAddress, log: EthereumLogObject, onNewChat: @escaping (String) -> Void
) {
  guard
    let event = try? ABI.decodeLog(event: ChatListContract.ChatCreated, from: log),
    let author = event["author"] as? EthereumAddress,
    let recipient = event["recipient"] as? EthereumAddress,
    let chat = event["chatContract"] as? EthereumAddress,
    author == caller || recipient == caller
  else { return }

  onNewChat(chat.hex(eip55: true))
}
