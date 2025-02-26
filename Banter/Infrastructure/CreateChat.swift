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
    !chainId.isEmpty, let chainId = Int(chainId), let chainId = BigUInt(exactly: chainId)
  else { return }

  let contract = web3.eth.Contract(
    type: ChatListContract.self,
    address: contractAddress
  )

  firstly {
    web3.eth.getTransactionCount(address: callerKey.address, block: .latest)
  }.then { nonce in
    try contract
      .createChat(recipient: recipient)
      .createTransaction(
        nonce: nonce,
        gasPrice: EthereumQuantity(quantity: 21.gwei),
        maxFeePerGas: EthereumQuantity(quantity: 21.gwei),
        maxPriorityFeePerGas: EthereumQuantity(quantity: 21.gwei),
        gasLimit: 1_000_000,
        from: callerKey.address,
        value: 0,
        accessList: [:],
        transactionType: .eip1559
      )!
      .sign(
        with: callerKey,
        chainId: EthereumQuantity(quantity: chainId)
      )
      .promise
  }.then { transaction in
    web3.eth.sendRawTransaction(transaction: transaction)
  }.done { hash in
    print("Created in transaction \(hash.hex())")
  }.catch { error in
    print("Error creating chat: \(error)")
  }
}
