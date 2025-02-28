// MockWeb3Async.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3
import Web3ContractABI
import Foundation

@testable import Banter

final class MockWeb3Async: Web3Async {
  private let gasPriceResult: Result<EthereumQuantity, Error>

  init(gasPriceResult: Result<EthereumQuantity, Error>) {
    self.gasPriceResult = gasPriceResult
  }

  func getTransactionCount(
    for _: EthereumAddress, block _: EthereumQuantityTag
  ) async throws -> EthereumQuantity {
    throw NSError(domain: "Test", code: 0, userInfo: nil)
  }

  func gasPrice() async throws -> EthereumQuantity {
    switch gasPriceResult {
    case let .success(price):
      return price
    case let .failure(error):
      throw error
    }
  }

  func estimateGas(
    _: SolidityInvocation,
    from _: EthereumAddress?,
    gas _: EthereumQuantity?,
    value _: EthereumQuantity?
  ) async throws -> EthereumQuantity {
    throw NSError(domain: "Test", code: 0, userInfo: nil)
  }

  func call(_: SolidityInvocation) async throws -> [String: Any] {
    throw NSError(domain: "Test", code: 0, userInfo: nil)
  }

  func sendRawTransaction(
    transaction _: EthereumSignedTransaction
  ) async throws -> EthereumData {
    throw NSError(domain: "Test", code: 0, userInfo: nil)
  }

  func getLogs(
    addresses _: [EthereumAddress]?,
    topics _: [[EthereumData]]?,
    fromBlock _: EthereumQuantityTag,
    toBlock _: EthereumQuantityTag
  ) async throws -> [EthereumLogObject] {
    throw NSError(domain: "Test", code: 0, userInfo: nil)
  }

  func subscribeToLogs(
    addresses _: [EthereumAddress]?, topics _: [[EthereumData]]?
  ) -> AsyncThrowingStream<EthereumLogObject, Error> {
    AsyncThrowingStream { continuation in
      continuation.finish(throwing: NSError(domain: "Test", code: 0, userInfo: nil))
    }
  }
}
