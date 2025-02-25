// ChatListContract.swift is a part of Web3Chat project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 20/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3
import Web3ContractABI

// Add ChatInfo struct
struct ChatInfo {
  let chatContract: EthereumAddress
  let author: EthereumAddress
  let recipient: EthereumAddress
  let createdAt: BigUInt
  let exists: Bool
}



protocol ChatListContractProtocol: EthereumContract {
  // Events
  static var ChatCreated: SolidityEvent { get }

  // Read methods
  func getUserChats() -> SolidityInvocation
  func getChat() -> SolidityInvocation

  // Write methods
  func createChat(recipient: EthereumAddress) -> SolidityInvocation
}

final class ChatListContract: StaticContract, ChatListContractProtocol {
  var address: EthereumAddress?
  let eth: Web3.Eth

  var constructor: SolidityConstructor?

  var events: [SolidityEvent] {
    [ChatListContract.ChatCreated]
  }

  required init(address: EthereumAddress?, eth: Web3.Eth) {
    self.address = address
    self.eth = eth
  }
}

extension ChatListContract {
  static var ChatCreated: SolidityEvent {
    let inputs: [SolidityEvent.Parameter] = [
      SolidityEvent.Parameter(name: "author", type: .address, indexed: true),
      SolidityEvent.Parameter(name: "recipient", type: .address, indexed: true),
      SolidityEvent.Parameter(name: "chatContract", type: .address, indexed: false),
      SolidityEvent.Parameter(name: "createdAt", type: .uint256, indexed: false)
    ]
    return SolidityEvent(name: "ChatCreated", anonymous: false, inputs: inputs)
  }

  static var ChatInfo: SolidityType {
    .tuple([
      .address, // chatContract
      .address, // author
      .address, // recipient
      .uint256, // createdAt
      .bool // exists
    ])
  }

  func getUserChats() -> SolidityInvocation {
    let outputs = [
      SolidityFunctionParameter(
        name: "",
        type: .array(
          type: ChatListContract.ChatInfo,
          length: nil
        )
      )
    ]
    let method = SolidityConstantFunction(name: "getUserChats", outputs: outputs, handler: self)
    return method.invoke()
  }

  func getChat() -> SolidityInvocation {
    let inputs = [
      SolidityFunctionParameter(name: "chatContract", type: .address)
    ]
    let outputs = [
      SolidityFunctionParameter(
        name: "",
        type: ChatListContract.ChatInfo
      )
    ]
    let method = SolidityConstantFunction(
      name: "getChat", inputs: inputs, outputs: outputs, handler: self
    )
    return method.invoke()
  }

  func createChat(recipient: EthereumAddress) -> SolidityInvocation {
    let inputs = [
      SolidityFunctionParameter(name: "recipient", type: .address)
    ]
    let outputs = [
      SolidityFunctionParameter(name: "", type: .address) // returns chatContract address
    ]
    let method = SolidityNonPayableFunction(
      name: "createChat", inputs: inputs, outputs: outputs, handler: self
    )
    return method.invoke(recipient)
  }
}
