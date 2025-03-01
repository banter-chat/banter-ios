// GetMessages.swift is a part of Banter project
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

func getMessages(chatAddress: String, onMessage: @escaping (String) -> Void) {
  @Shared(.web3Settings) var settings

  guard
    let web3 = try? Web3(wsUrl: settings.rpcWSURL),
    let contractAddress = try? EthereumAddress(hex: chatAddress, eip55: false)
  else { return }

  web3.eth.getLogs(addresses: [contractAddress],
                   topics: nil,
                   fromBlock: .earliest,
                   toBlock: .latest) { resp in
    guard let logs = resp.result else { return }
    for log in logs {
      processMessageEvent(log: log, onMessage: onMessage)
    }
  }

  try! web3.eth.subscribeToLogs(addresses: [contractAddress]) { _ in
    print("subscribed")
  } onEvent: { resp in
    guard let log = resp.result else { return }
    processMessageEvent(log: log, onMessage: onMessage)
  }
}

func processMessageEvent(log: EthereumLogObject, onMessage: @escaping (String) -> Void) {
  guard
    let event = try? ABI.decodeLog(event: ChatContract.MessageSent, from: log),
    let message = event["message"] as? String
  else { return }

  onMessage(message)
}
