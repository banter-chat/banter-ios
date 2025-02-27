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

protocol Web3ClientProtocol {
  func call(_ invocation: SolidityInvocation) async throws -> [String: Any]
  func send(_ invocation: SolidityInvocation, value: EthereumQuantity) async throws
  func subscribe(
    contract: EthereumContract, events: [SolidityEvent]
  ) -> AsyncStream<[String: Any]>
}

extension Web3ClientProtocol {
  func send(_ invocation: SolidityInvocation) async throws {
    try await send(invocation, value: 0)
  }
}

struct Web3Client: Web3ClientProtocol {
  let web3: Web3
  let callerKey: EthereumPrivateKey
  let chainId: UInt64
  func call(_ invocation: SolidityInvocation) async throws -> [String: Any] {
    try await asyncWrapper(invocation.call)
  }

  func send(_ invocation: SolidityInvocation, value: EthereumQuantity = 0) async throws {
    try await asyncWrapper { callback in
      when(
        fulfilled: web3.eth.gasPrice(),
        web3.eth.getTransactionCount(address: callerKey.address, block: .latest),
        invocation.estimateGas()
      ).then { gasPrice, nonce, gas in
        let quantity = gasPrice.quantity
        let maxFee = quantity * BigUInt(exactly: 110)! / BigUInt(exactly: 100)!
        let maxPriority = quantity * BigUInt(exactly: 10)! / BigUInt(exactly: 100)!
        let maxTip = min(maxPriority, 1.gwei)
        let gasLimit = gas.quantity * BigUInt(exactly: 120)! / BigUInt(exactly: 100)!

        return try invocation
          .createTransaction(
            nonce: nonce,
            gasPrice: gasPrice,
            maxFeePerGas: EthereumQuantity(quantity: maxFee),
            maxPriorityFeePerGas: EthereumQuantity(quantity: maxTip),
            gasLimit: EthereumQuantity(quantity: gasLimit),
            from: callerKey.address,
            value: value,
            accessList: [:],
            transactionType: .eip1559
          )!
          .sign(
            with: callerKey,
            chainId: EthereumQuantity(integerLiteral: chainId)
          )
          .promise
      }.then { transaction in
        web3.eth.sendRawTransaction(transaction: transaction)
      }.done { transactionHash in
        print("Transaction sent \(transactionHash.hex())")
      }.catch { error in
        callback((), error)
      }
    }
  }

  func subscribe(
    contract _: EthereumContract, events _: [SolidityEvent]
  ) -> AsyncStream<[String: Any]> {
    fatalError("Not implemented")
  }
}

// MARK: - Async helpers

// Original callback-based function type
private typealias CallbackFunction<T> = (T?, Error?) -> Void

// Wrapper that converts to async/throws
private func asyncWrapper<T>(
  _ callbackFunction: @escaping (@escaping CallbackFunction<T>) -> Void
) async throws -> T {
  try await withCheckedThrowingContinuation { continuation in
    callbackFunction { result, error in
      if let error {
        continuation.resume(throwing: error)
      } else if let result {
        continuation.resume(returning: result)
      } else {
        continuation.resume(
          throwing: NSError(
            domain: "AsyncWrapperError", code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Both result and error were nil"]
          ))
      }
    }
  }
}
