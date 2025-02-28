// Web3FeesEstimatorTests.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Testing
import Web3

@testable import Banter

@Suite("Web3FeesEstimator Tests")
struct Web3FeesEstimatorTests {
  @Test("BasicWeb3FeesEstimator returns correct fees")
  func testBasicWeb3FeesEstimatorReturnsCorrectFees() async throws {
    // Given
    let mockGasPrice = EthereumQuantity(quantity: 20.gwei)
    let mockWeb3 = MockWeb3Async()
    mockWeb3.priceResult = .success(mockGasPrice)
    let estimator = BasicWeb3FeesEstimator()

    // When
    let fees = try await estimator.estimateFees(web3: mockWeb3)

    // Then
    #expect(fees.maxFeePerGas == mockGasPrice)
    #expect(fees.maxPriorityFeePerGas == EthereumQuantity(quantity: 1.gwei))
  }

  @Test("BasicWeb3FeesEstimator propagates errors from web3")
  func testBasicWeb3FeesEstimatorPropagatesErrors() async {
    // Given
    struct TestError: Error {}
    let mockError = TestError()
    let mockWeb3 = MockWeb3Async()
    mockWeb3.priceResult = .failure(mockError)
    let estimator = BasicWeb3FeesEstimator()

    // When/Then
    var errorThrown = false

    do {
      _ = try await estimator.estimateFees(web3: mockWeb3)
    } catch {
      errorThrown = true
      #expect(error is TestError)
    }

    #expect(errorThrown, "Expected error to be thrown")
  }
}
