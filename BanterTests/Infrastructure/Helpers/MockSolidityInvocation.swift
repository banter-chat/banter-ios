// MockSolidityInvocation.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import OrderedCollections
import Web3
import Web3ContractABI

class MockSolidityInvocation: SolidityInvocation {
  var method: SolidityFunction { fatalError("Not implemented") }
  var parameters: [SolidityWrappedValue] { fatalError("Not implemented") }
  var handler: SolidityFunctionHandler { fatalError("Not implemented") }

  // Control behavior for testing
  var shouldFailTransactionCreation = false
  var mockTransaction: EthereumTransaction?

  func createTransaction(
    nonce: EthereumQuantity?,
    gasPrice: EthereumQuantity?,
    maxFeePerGas: EthereumQuantity?,
    maxPriorityFeePerGas: EthereumQuantity?,
    gasLimit: EthereumQuantity?,
    from: EthereumAddress?,
    value: EthereumQuantity?,
    accessList: OrderedDictionary<EthereumAddress, [EthereumData]>,
    transactionType: EthereumTransaction.TransactionType
  ) -> EthereumTransaction? {
    if shouldFailTransactionCreation {
      return nil
    }

    if let mockTransaction {
      return mockTransaction
    }

    // Create a transaction with the passed parameters
    return EthereumTransaction(
      nonce: nonce,
      gasPrice: gasPrice,
      maxFeePerGas: maxFeePerGas,
      maxPriorityFeePerGas: maxPriorityFeePerGas,
      gasLimit: gasLimit,
      from: from,
      to: from,
      value: value,
      data: EthereumData([]),
      accessList: accessList,
      transactionType: transactionType
    )
  }

  func createCall() -> EthereumCall? {
    nil
  }

  func send(
    nonce _: EthereumQuantity?,
    gasPrice _: EthereumQuantity?,
    maxFeePerGas _: EthereumQuantity?,
    maxPriorityFeePerGas _: EthereumQuantity?,
    gasLimit _: EthereumQuantity?,
    from _: EthereumAddress,
    value _: EthereumQuantity?,
    accessList _: OrderedDictionary<EthereumAddress, [EthereumData]>,
    transactionType _: EthereumTransaction.TransactionType,
    completion: @escaping (EthereumData?, (any Error)?) -> Void
  ) {
    completion(nil, nil)
  }

  func call(
    block _: EthereumQuantityTag,
    completion: @escaping ([String: Any]?, (any Error)?) -> Void
  ) {
    completion(nil, nil)
  }

  init(
    shouldFailTransactionCreation: Bool = false,
    mockTransaction: EthereumTransaction? = nil
  ) {
    self.shouldFailTransactionCreation = shouldFailTransactionCreation
    self.mockTransaction = mockTransaction
  }

  // Required by the protocol but we won't use it
  required init(
    method _: SolidityFunction,
    parameters _: [any ABIEncodable],
    handler _: SolidityFunctionHandler
  ) {
    fatalError("Not implemented")
  }
}
