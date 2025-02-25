// ChatContract.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3
import Web3ContractABI

protocol ChatContractProtocol: EthereumContract {
  // Events
  static var MessageSent: SolidityEvent { get }

  // Write methods
  func sendMessage(message: String) -> SolidityInvocation
}

final class ChatContract: StaticContract, ChatContractProtocol {
  var address: EthereumAddress?
  let eth: Web3.Eth

  var constructor: SolidityConstructor?

  var events: [SolidityEvent] {
    [ChatContract.MessageSent]
  }

  required init(address: EthereumAddress?, eth: Web3.Eth) {
    self.address = address
    self.eth = eth
  }
}

extension ChatContract {
  static var MessageSent: SolidityEvent {
    let inputs: [SolidityEvent.Parameter] = [
      SolidityEvent.Parameter(name: "sender", type: .address, indexed: true),
      SolidityEvent.Parameter(name: "message", type: .string, indexed: false),
      SolidityEvent.Parameter(name: "timestamp", type: .uint256, indexed: false)
    ]
    return SolidityEvent(name: "MessageSent", anonymous: false, inputs: inputs)
  }

  func sendMessage(message: String) -> SolidityInvocation {
    let inputs = [
      SolidityFunctionParameter(name: "message", type: .string)
    ]
    let method = SolidityNonPayableFunction(
      name: "sendMessage", inputs: inputs, outputs: nil, handler: self
    )
    return method.invoke(message)
  }
}
