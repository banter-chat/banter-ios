// CreateChat.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Sharing
import Web3
import Web3ContractABI
import Web3PromiseKit

func createChat(recipient: String) {
  @Shared(.rpcWSURL) var rpcWSURL
  @Shared(.chainId) var chainId
  @Shared(.chatListAddress) var chatListAddress
  @Shared(.walletKeyHex) var walletKeyHex

  guard
    let web3 = try? Web3(wsUrl: rpcWSURL),
    let contractAddress = try? EthereumAddress(hex: chatListAddress, eip55: false),
    let callerKey = try? EthereumPrivateKey(hexPrivateKey: walletKeyHex),
    let recipient = try? EthereumAddress(hex: recipient, eip55: false),
    let chainId = UInt64(chainId)
  else { return }

  let web3Wrapper = Web3AsyncAdapter.live(web3: web3)

  let contract = ChatListContract(address: contractAddress, eth: web3.eth)

  let client = BasicWeb3Client(web3: web3Wrapper, chainId: chainId)
  let key = BasicWeb3WalletKey(privateKey: callerKey)
  let invocation = contract.createChat(recipient: recipient)

  Task {
    do {
      try await client.send(invocation, key: key)
    } catch {
      print("Error creating chat: \(error)")
    }
  }
}
