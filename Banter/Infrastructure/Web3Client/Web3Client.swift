// Web3Client.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import ConcurrencyExtras
import Web3
import Web3ContractABI
import Web3PromiseKit

protocol Web3Client {
  func call(_ invocation: SolidityInvocation) async throws -> [String: Any]
  func send(
    _ invocation: SolidityInvocation, value: EthereumQuantity, key: Web3WalletKey
  ) async throws

  func find(
    contractAddress: EthereumAddress,
    event: SolidityEvent,
    from: EthereumQuantityTag,
    to: EthereumQuantityTag
  ) async throws -> [[String: Any]]

  func subscribe(
    contractAddress: EthereumAddress,
    event: SolidityEvent
  ) -> AsyncThrowingStream<[String: Any], Error>
}

extension Web3Client {
  func send(_ invocation: SolidityInvocation, key: Web3WalletKey) async throws {
    try await send(invocation, value: 0, key: key)
  }

  func find(
    contractAddress: EthereumAddress,
    event: SolidityEvent,
    from: EthereumQuantityTag = .latest,
    to: EthereumQuantityTag = .latest
  ) async throws -> [[String: Any]] {
    try await find(contractAddress: contractAddress, event: event, from: from, to: to)
  }
}

struct BasicWeb3Client: Web3Client {
  let web3: Web3AsyncAdapter
  let chainId: UInt64

  var builder: Web3TransactionBuilding = Web3TransactionBuilder()
  var estimator: Web3FeesEstimator = BasicWeb3FeesEstimator()

  func call(_ invocation: SolidityInvocation) async throws -> [String: Any] {
    try await web3.call(invocation)
  }

  func send(
    _ invocation: SolidityInvocation,
    value: EthereumQuantity = 0,
    key: Web3WalletKey
  ) async throws {
    async let nonce = try await web3.getTransactionCount(for: key.address)
    async let prices = try await estimator.estimateFees(web3: web3)
    async let gasLimit = try await web3.estimateGas(invocation: invocation)

    let transaction = try await builder.build(invocation,
                                              sender: key.address,
                                              value: value,
                                              nonce: nonce,
                                              prices: prices,
                                              gasLimit: gasLimit)

    let signedTransaction = try key.sign(transaction, chainId: chainId)
    _ = try await web3.sendRawTransaction(transaction: signedTransaction)
  }

  func find(
    contractAddress: EthereumAddress,
    event: SolidityEvent,
    from: EthereumQuantityTag,
    to: EthereumQuantityTag
  ) async throws -> [[String: Any]] {
    let logs = try await web3.getLogs(addresses: [contractAddress],
                                      topics: nil,
                                      fromBlock: from,
                                      toBlock: to)

    return logs.compactMap { try? ABI.decodeLog(event: event, from: $0) }
  }

  func subscribe(
    contractAddress: EthereumAddress,
    event: SolidityEvent
  ) -> AsyncThrowingStream<[String: Any], Error> {
    let stream = web3.subscribeToLogs(addresses: [contractAddress])
    let eventsStream = stream.compactMap { try? ABI.decodeLog(event: event, from: $0) }
    return UncheckedSendable(eventsStream).eraseToThrowingStream()
  }
}
