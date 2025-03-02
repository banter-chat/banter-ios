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

struct Web3AsyncAdapter: Web3Async {
  private let web3: Web3

  init(web3: Web3) {
    self.web3 = web3
  }

  func getTransactionCount(
    for address: EthereumAddress, block: EthereumQuantityTag
  ) async throws -> EthereumQuantity {
    let result = await asyncWrapper { callback in
      web3.eth.getTransactionCount(address: address, block: block) { response in
        callback(response.status.asResult)
      }
    }

    return try result.get()
  }

  func gasPrice() async throws -> EthereumQuantity {
    let result = await asyncWrapper { callback in
      web3.eth.gasPrice { response in
        callback(response.status.asResult)
      }
    }

    return try result.get()
  }

  func estimateGas(
    invocation: SolidityInvocation,
    from: EthereumAddress? = nil,
    gas: EthereumQuantity? = nil,
    value: EthereumQuantity? = nil
  ) async throws -> EthereumQuantity {
    let result = await asyncWrapper { callback in
      invocation.estimateGas(from: from, gas: gas, value: value) { data, error in
        callback(getResult(data, error))
      }
    }

    return try result.get()
  }

  func call(_ invocation: SolidityInvocation) async throws -> [String: Any] {
    let result = await asyncWrapper { callback in
      invocation.call { data, error in
        callback(getResult(data, error))
      }
    }

    return try result.get()
  }

  func sendRawTransaction(
    transaction: EthereumSignedTransaction
  ) async throws -> EthereumData {
    let result = try await throwingAsyncWrapper { callback in
      try web3.eth.sendRawTransaction(transaction: transaction) { response in
        callback(response.status.asResult)
      }
    }

    return try result.get()
  }

  func getLogs(
    addresses: [EthereumAddress]?,
    topics: [[EthereumData]]?,
    fromBlock: EthereumQuantityTag,
    toBlock: EthereumQuantityTag
  ) async throws -> [EthereumLogObject] {
    let result = await asyncWrapper { callback in
      web3.eth.getLogs(
        addresses: addresses, topics: topics, fromBlock: fromBlock, toBlock: toBlock
      ) { response in
        callback(response.status.asResult)
      }
    }

    return try result.get()
  }

  func subscribeToLogs(
    addresses: [EthereumAddress]?, topics: [[EthereumData]]?
  ) -> AsyncThrowingStream<EthereumLogObject, Error> {
    AsyncThrowingStream { continuation in
      var ongoingSubscriptionId: String?

      do {
        try web3.eth.subscribeToLogs(addresses: addresses, topics: topics) { response in
          switch response.status {
          case let .failure(error):
            continuation.finish(throwing: error)
          case let .success(subscriptionId):
            ongoingSubscriptionId = subscriptionId
          }
        } onEvent: { response in
          switch response.status {
          case let .success(log):
            continuation.yield(log)
          case let .failure(error):
            continuation.finish(throwing: error)
          }
        }
      } catch {
        continuation.finish(throwing: error)
      }

      continuation.onTermination = { [ongoingSubscriptionId] _ in
        if let ongoingSubscriptionId {
          try? web3.eth.unsubscribe(subscriptionId: ongoingSubscriptionId) { _ in }
        }
      }
    }
  }
}
