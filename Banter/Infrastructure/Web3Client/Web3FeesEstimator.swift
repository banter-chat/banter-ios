// Web3FeesEstimator.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3
import Web3ContractABI

protocol Web3FeesEstimation {
  func estimateFees(api: Web3.Eth) async throws -> Fees
}

struct Fees {
  let gasPrice: EthereumQuantity
  let maxFeePerGas: EthereumQuantity
  let maxPriorityFeePerGas: EthereumQuantity
}

struct Web3FeesEstimator: Web3FeesEstimation {
  func estimateFees(api: Web3.Eth) async throws -> Fees {
    let gasPrice = try await getGasPrice(api)
    let quantity = gasPrice.quantity
    let maxFee = quantity * BigUInt(exactly: 110)! / BigUInt(exactly: 100)!
    let maxPriority = quantity * BigUInt(exactly: 10)! / BigUInt(exactly: 100)!
    let maxTip = min(maxPriority, 1.gwei)

    return Fees(
      gasPrice: gasPrice,
      maxFeePerGas: EthereumQuantity(quantity: maxFee),
      maxPriorityFeePerGas: EthereumQuantity(quantity: maxTip)
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
