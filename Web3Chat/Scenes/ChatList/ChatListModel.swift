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

  func loadChatsTapped() {
    getChats { result in
      guard let chats = try? result.get() else { return }
      DispatchQueue.main.async {
        self.chats = chats.map { Chat(address: $0) }
      }
    }
  }
}

import Web3
import Web3ContractABI

func getChats(completion: @escaping (Result<[String], Error>) -> Void) {
  let web3 = Web3(rpcURL: "https://virtual.sepolia.rpc.tenderly.co/98127e94-dbd9-4623-a1cb-d59bb30019d1")

  let contractHex = "0xB13E8C24ad747788232d4d035Be3E0e029Ac3008"
  let contractAddress = try! EthereumAddress(hex: contractHex, eip55: true)

  let jsonABI = """
  [
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "newChat",
          "type": "string"
        }
      ],
      "name": "addChat",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getChats",
      "outputs": [
        {
          "internalType": "string[]",
          "name": "availableChats",
          "type": "string[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
  """.data(using: .utf8)!

  let contract = try! web3.eth.Contract(json: jsonABI, abiKey: nil, address: contractAddress)

  contract["getChats"]!().call { response, _ in
    let chatsArray = response!["availableChats"]! as! [String]
    completion(.success(chatsArray))
  }
}
