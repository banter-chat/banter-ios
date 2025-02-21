// ChatListContract.swift is a part of Web3Chat project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 20/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3
import Web3ContractABI

public protocol ChatListContractProtocol: EthereumContract {
  static var NewChat: SolidityEvent { get }
}

final class ChatListContract: StaticContract, ChatListContractProtocol {
  var address: EthereumAddress?
  let eth: Web3.Eth

  var constructor: SolidityConstructor?

  var events: [SolidityEvent] {
    [ChatListContract.NewChat]
  }

  required init(address: EthereumAddress?, eth: Web3.Eth) {
    self.address = address
    self.eth = eth
  }
}

extension ChatListContract {
  static var NewChat: SolidityEvent {
    let inputs: [SolidityEvent.Parameter] = [
      SolidityEvent.Parameter(name: "name", type: .string, indexed: false)
    ]
    return SolidityEvent(name: "NewChat", anonymous: false, inputs: inputs)
  }
}
