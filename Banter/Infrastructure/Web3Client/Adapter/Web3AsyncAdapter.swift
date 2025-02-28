// Web3AsyncAdapter.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Web3
import Web3ContractABI
import Web3PromiseKit

extension Web3AsyncAdapter {
  func call(_ invocation: SolidityInvocation) async throws -> [String: Any] {
    try await call(invocation)
  }

  func getLogs(
    addresses: [EthereumAddress]?,
    topics: [[EthereumData]]?,
    fromBlock: EthereumQuantityTag,
    toBlock: EthereumQuantityTag
  ) async throws -> [EthereumLogObject] {
    try await getLogs(addresses, topics, fromBlock, toBlock)
  }

  func estimateGas(
    invocation: SolidityInvocation,
    from: EthereumAddress? = nil,
    gas: EthereumQuantity? = nil,
    value: EthereumQuantity? = nil
  ) async throws -> EthereumQuantity {
    try await estimateGas(invocation, from, gas, value)
  }

  func getTransactionCount(
    for address: EthereumAddress, block: EthereumQuantityTag = .latest
  ) async throws -> EthereumQuantity {
    try await getTransactionCount(address, block)
  }

  func sendRawTransaction(
    transaction: EthereumSignedTransaction
  ) async throws -> EthereumData {
    try await sendRawTransaction(transaction)
  }

  func subscribeToLogs(
    addresses: [EthereumAddress]? = nil, topics: [[EthereumData]]? = nil
  ) -> AsyncThrowingStream<EthereumLogObject, Error> {
    subscribeToLogs(addresses, topics)
  }
}

struct Web3AsyncAdapter {
  var getTransactionCount: (
    _ address: EthereumAddress, _ block: EthereumQuantityTag
  ) async throws -> EthereumQuantity

  var gasPrice: () async throws -> EthereumQuantity

  var estimateGas: (
    _ invocation: SolidityInvocation,
    _ from: EthereumAddress?,
    _ gas: EthereumQuantity?,
    _ value: EthereumQuantity?
  ) async throws -> EthereumQuantity

  var call: (SolidityInvocation) async throws -> [String: Any]

  var sendRawTransaction: (
    _ transaction: EthereumSignedTransaction
  ) async throws -> EthereumData

  var getLogs: (
    _ addresses: [EthereumAddress]?,
    _ topics: [[EthereumData]]?,
    _ fromBlock: EthereumQuantityTag,
    _ toBlock: EthereumQuantityTag
  ) async throws -> [EthereumLogObject]

  var subscribeToLogs: (
    _ addresses: [EthereumAddress]?, _ topics: [[EthereumData]]?
  ) -> AsyncThrowingStream<EthereumLogObject, Error>
}
