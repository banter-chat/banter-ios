// Web3TransactionBuilder.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3
import Web3ContractABI

protocol Web3TransactionBuilding {
  func build(
    _ invocation: SolidityInvocation,
    sender: EthereumAddress,
    value: EthereumQuantity,
    nonce: EthereumQuantity,
    prices: Fees,
    gasLimit: EthereumQuantity
  ) throws -> EthereumTransaction
}

struct Web3TransactionBuilder: Web3TransactionBuilding {
  func build(
    _ invocation: SolidityInvocation,
    sender: EthereumAddress,
    value: EthereumQuantity,
    nonce: EthereumQuantity,
    prices: Fees,
    gasLimit: EthereumQuantity
  ) throws -> EthereumTransaction {
    guard let transaction = invocation
      .createTransaction(
        nonce: nonce,
        gasPrice: prices.gasPrice,
        maxFeePerGas: prices.maxFeePerGas,
        maxPriorityFeePerGas: prices.maxPriorityFeePerGas,
        gasLimit: gasLimit,
        from: sender,
        value: value,
        accessList: [:],
        transactionType: .eip1559
      )
    else {
      throw Web3TransactionBuilderError.transactionCreationFailed
    }

    return transaction
  }
}

enum Web3TransactionBuilderError: Error {
  case transactionCreationFailed
}
