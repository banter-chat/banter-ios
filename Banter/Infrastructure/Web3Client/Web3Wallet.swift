// Web3Wallet.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3

protocol Web3Wallet {
  var address: EthereumAddress { get }

  func getNonce(api: Web3.Eth) async throws -> EthereumQuantity
  func sign(
    _ transaction: EthereumTransaction, chainId: UInt64
  ) throws -> EthereumSignedTransaction
}

struct BasicWeb3Wallet: Web3Wallet {
  let privateKey: EthereumPrivateKey
  var address: EthereumAddress { privateKey.address }

  func getNonce(api: Web3.Eth) async throws -> EthereumQuantity {
    try await asyncWrapper { callback in
      api.getTransactionCount(address: address, block: .latest) {
        let result = getResult($0.result, $0.error)
        callback(result)
      }
    }
  }

  func sign(
    _ transaction: EthereumTransaction, chainId: UInt64
  ) throws -> EthereumSignedTransaction {
    try transaction.sign(
      with: privateKey,
      chainId: EthereumQuantity(integerLiteral: chainId)
    )
  }
}
