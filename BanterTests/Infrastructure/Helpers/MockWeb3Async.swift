// MockWeb3Async.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Web3
import Web3ContractABI

@testable import Banter

class MockWeb3Async: Web3Async {
  var getTransactionCountResult: Result<EthereumQuantity, Error> = .failure(MockWeb3AsyncError.notSet)
  var getTransactionCountCalledWith: (EthereumAddress, EthereumQuantityTag)?
  func getTransactionCount(
    for address: EthereumAddress, block: EthereumQuantityTag
  ) async throws -> EthereumQuantity {
    getTransactionCountCalledWith = (address, block)
    return try getTransactionCountResult.get()
  }

  var priceResult: Result<EthereumQuantity, Error> = .failure(MockWeb3AsyncError.notSet)
  var gasPriceCalled = false
  func gasPrice() async throws -> EthereumQuantity {
    gasPriceCalled = true
    return try priceResult.get()
  }

  var estimatedGasResult: Result<EthereumQuantity, Error> = .failure(MockWeb3AsyncError.notSet)
  var estimateGasCalledWith: (
    SolidityInvocation, EthereumAddress?, EthereumQuantity?, EthereumQuantity?
  )?
  func estimateGas(
    _ invocation: SolidityInvocation,
    from: EthereumAddress?,
    gas: EthereumQuantity?,
    value: EthereumQuantity?
  ) async throws -> EthereumQuantity {
    estimateGasCalledWith = (invocation, from, gas, value)
    return try estimatedGasResult.get()
  }

  var callResult: Result<[String: Any], Error> = .failure(MockWeb3AsyncError.notSet)
  var callCalledWith: SolidityInvocation?
  func call(_ invocation: SolidityInvocation) async throws -> [String: Any] {
    callCalledWith = invocation
    return try callResult.get()
  }

  var rawTransactionResult: Result<EthereumData, Error> = .failure(MockWeb3AsyncError.notSet)
  var sendRawTransactionCalledWith: EthereumSignedTransaction?
  func sendRawTransaction(
    transaction: EthereumSignedTransaction
  ) async throws -> EthereumData {
    sendRawTransactionCalledWith = transaction
    return try rawTransactionResult.get()
  }

  var getLogsResult: Result<[EthereumLogObject], Error> = .failure(MockWeb3AsyncError.notSet)
  var getLogsCalledWith: ([EthereumAddress]?, [[EthereumData]]?, EthereumQuantityTag, EthereumQuantityTag)?
  func getLogs(
    addresses: [EthereumAddress]?,
    topics: [[EthereumData]]?,
    fromBlock: EthereumQuantityTag,
    toBlock: EthereumQuantityTag
  ) async throws -> [EthereumLogObject] {
    getLogsCalledWith = (addresses, topics, fromBlock, toBlock)
    return try getLogsResult.get()
  }

  func subscribeToLogs(
    addresses _: [EthereumAddress]?, topics _: [[EthereumData]]?
  ) -> AsyncThrowingStream<EthereumLogObject, Error> {
    AsyncThrowingStream { continuation in
      continuation.finish(throwing: NSError(domain: "Test", code: 0, userInfo: nil))
    }
  }
}

enum MockWeb3AsyncError: Error {
  case notSet
}
