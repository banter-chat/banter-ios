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

protocol Web3ClientProtocol {
  func call(_ invocation: SolidityInvocation) async throws -> [String: Any]
  func send(_ invocation: SolidityInvocation) async throws -> [String: Any]
  func subscribe(
    contract: EthereumContract, events: [SolidityEvent]
  ) -> AsyncStream<[String: Any]>
}

struct Web3Client: Web3ClientProtocol {
  let web3: Web3

  func call(_ invocation: SolidityInvocation) async throws -> [String: Any] {
    try await asyncWrapper(invocation.call)
  }

  func send(_: SolidityInvocation) async throws -> [String: Any] {
    fatalError("Not implemented")
  }

  func subscribe(contract _: EthereumContract, events _: [SolidityEvent]) -> AsyncStream<[String: Any]> {
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
