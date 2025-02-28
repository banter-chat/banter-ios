// Web3FeesEstimator.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3

protocol Web3FeesEstimator {
  func estimateFees(web3: Web3AsyncAdapter) async throws -> Fees
}

struct Fees {
  let maxFeePerGas: EthereumQuantity
  let maxPriorityFeePerGas: EthereumQuantity
}

struct BasicWeb3FeesEstimator: Web3FeesEstimator {
  func estimateFees(web3: Web3AsyncAdapter) async throws -> Fees {
    let gasPrice = try await web3.gasPrice()

    return Fees(
      maxFeePerGas: gasPrice,
      maxPriorityFeePerGas: EthereumQuantity(quantity: 1.gwei)
    )
  }
}
