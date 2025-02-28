// Web3Client.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Web3
import Web3ContractABI
import Web3PromiseKit

protocol Web3Client {
  func call(_ invocation: SolidityInvocation) async throws -> [String: Any]
  func send(_ invocation: SolidityInvocation, value: EthereumQuantity) async throws

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
  func send(_ invocation: SolidityInvocation) async throws {
    try await send(invocation, value: 0)
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
  let ethAPI: Web3.Eth
  let chainId: UInt64

  let wallet: Web3Wallet
  let builder: Web3TransactionBuilding
  let estimator: Web3FeesEstimation

  func call(_ invocation: SolidityInvocation) async throws -> [String: Any] {
    try await asyncWrapper { callback in
      invocation.call { data, error in
        let result = getResult(data, error)
        callback(result)
      }
    }
  }

  func send(_ invocation: SolidityInvocation, value: EthereumQuantity = 0) async throws {
    async let nonce = try await wallet.getNonce(api: ethAPI)
    async let prices = try await estimator.estimateFees(api: ethAPI)
    async let gasLimit = try await estimate(invocation: invocation)

    let transaction = try await builder.build(invocation,
                                              sender: wallet.address,
                                              value: value,
                                              nonce: nonce,
                                              prices: prices,
                                              gasLimit: gasLimit)

    let signedTransaction = try wallet.sign(transaction, chainId: chainId)
    try await execute(transaction: signedTransaction)
  }

  func find(
    contractAddress: EthereumAddress,
    event: SolidityEvent,
    from: EthereumQuantityTag,
    to: EthereumQuantityTag
  ) async throws -> [[String: Any]] {
    try await asyncWrapper { callback in
      ethAPI.getLogs(
        addresses: [contractAddress], topics: nil, fromBlock: from, toBlock: to
      ) { resp in
        let logs = resp.result ?? []
        let events = logs.compactMap { try? ABI.decodeLog(event: event, from: $0) }
        let result = getResult(events, resp.error)
        callback(result)
      }
    }
  }

  func subscribe(
    contractAddress: EthereumAddress,
    event: SolidityEvent
  ) -> AsyncThrowingStream<[String: Any], Error> {
    AsyncThrowingStream { continuation in
      var ongoingSubscriptionId: String?

      try? ethAPI.subscribeToLogs(addresses: [contractAddress]) { response in
        switch response.status {
        case let .failure(error):
          continuation.finish(throwing: error)
        case let .success(subscriptionId):
          ongoingSubscriptionId = subscriptionId
        }
      } onEvent: { log in
        switch log.status {
        case let .failure(error):
          continuation.finish(throwing: error)
        case let .success(log):
          if let event = try? ABI.decodeLog(event: event, from: log) {
            continuation.yield(event)
          }
        }
      }

      continuation.onTermination = { [ongoingSubscriptionId] _ in
        if let ongoingSubscriptionId {
          try? ethAPI.unsubscribe(subscriptionId: ongoingSubscriptionId) { _ in }
        }
      }
    }
  }

  private func execute(transaction: EthereumSignedTransaction) async throws {
    try await asyncWrapper { callback in
      try ethAPI.sendRawTransaction(transaction: transaction) {
        let result = getResult($0.result, $0.error)
        callback(result)
      }
    }
  }

  private func estimate(
    invocation: SolidityInvocation
  ) async throws -> EthereumQuantity {
    try await asyncWrapper { callback in
      invocation.estimateGas { data, error in
        let result = getResult(data, error)
        callback(result)
      }
    }
  }
}
