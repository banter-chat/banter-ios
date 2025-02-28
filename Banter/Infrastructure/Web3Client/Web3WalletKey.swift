// Web3WalletKey.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3

protocol Web3WalletKey {
  var address: EthereumAddress { get }

  func sign(
    _ transaction: EthereumTransaction, chainId: UInt64
  ) throws -> EthereumSignedTransaction
}

struct BasicWeb3WalletKey: Web3WalletKey {
  let privateKey: EthereumPrivateKey
  var address: EthereumAddress { privateKey.address }

  func sign(
    _ transaction: EthereumTransaction, chainId: UInt64
  ) throws -> EthereumSignedTransaction {
    try transaction.sign(
      with: privateKey,
      chainId: EthereumQuantity(integerLiteral: chainId)
    )
  }
}
