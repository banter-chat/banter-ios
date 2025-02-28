// Web3FeesEstimator.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3
import Web3ContractABI

protocol Web3FeesEstimator {
  func estimateFees(api: Web3.Eth) async throws -> Fees
}

struct Fees {
  let maxFeePerGas: EthereumQuantity
  let maxPriorityFeePerGas: EthereumQuantity
}

struct BasicWeb3FeesEstimator: Web3FeesEstimator {
  func estimateFees(api: Web3.Eth) async throws -> Fees {
    Fees(
      maxFeePerGas: try await getGasPrice(api),
      maxPriorityFeePerGas: EthereumQuantity(quantity: 1.gwei)
    )
  }

  private func getGasPrice(_ api: Web3.Eth) async throws -> EthereumQuantity {
    try await asyncWrapper { callback in
      api.gasPrice {
        let result = getResult($0.result, $0.error)
        callback(result)
      }
    }
  }
}
