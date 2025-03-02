// Web3TransactionBuilderTests.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import BigInt
import Foundation
import OrderedCollections
import Testing
import Web3
import Web3ContractABI

@testable import Banter

@Suite("Web3TransactionBuilder Tests")
struct Web3TransactionBuilderTests {
  @Test("Web3TransactionBuilder builds transaction successfully")
  func testWeb3TransactionBuilderBuildsTransactionSuccessfully() throws {
    // Given
    let builder = Web3TransactionBuilder()
    let mockInvocation = MockSolidityInvocation()

    let sender = EthereumAddress(hexString: "0x1234567890123456789012345678901234567890")!
    let value = EthereumQuantity(quantity: 1.eth)
    let nonce = EthereumQuantity(quantity: 5)
    let fees = Fees(
      maxFeePerGas: EthereumQuantity(quantity: 30.gwei),
      maxPriorityFeePerGas: EthereumQuantity(quantity: 15.gwei)
    )
    let gasLimit = EthereumQuantity(quantity: 100_000)

    // When
    let transaction = try builder.build(
      mockInvocation,
      sender: sender,
      value: value,
      nonce: nonce,
      prices: fees,
      gasLimit: gasLimit
    )

    // Then
    #expect(transaction.nonce == nonce)
    #expect(transaction.maxFeePerGas == fees.maxFeePerGas)
    #expect(transaction.maxPriorityFeePerGas == fees.maxPriorityFeePerGas)
    #expect(transaction.gasLimit == gasLimit)
    #expect(transaction.value == value)
    #expect(transaction.transactionType == .eip1559)
  }

  @Test("Web3TransactionBuilder throws error when transaction creation fails")
  func testWeb3TransactionBuilderThrowsErrorWhenTransactionCreationFails() {
    // Given
    let builder = Web3TransactionBuilder()
    let mockInvocation = MockSolidityInvocation(shouldFailTransactionCreation: true)

    let sender = EthereumAddress(hexString: "0x1234567890123456789012345678901234567890")!
    let value = EthereumQuantity(quantity: 1.eth)
    let nonce = EthereumQuantity(quantity: 5)
    let fees = Fees(
      maxFeePerGas: EthereumQuantity(quantity: 30.gwei),
      maxPriorityFeePerGas: EthereumQuantity(quantity: 15.gwei)
    )
    let gasLimit = EthereumQuantity(quantity: 100_000)

    // When/Then
    var errorThrown = false

    do {
      _ = try builder.build(
        mockInvocation,
        sender: sender,
        value: value,
        nonce: nonce,
        prices: fees,
        gasLimit: gasLimit
      )
    } catch {
      errorThrown = true
      #expect(error is Web3TransactionBuilderError)

      if let specificError = error as? Web3TransactionBuilderError {
        #expect(specificError == Web3TransactionBuilderError.transactionCreationFailed)
      }
    }

    #expect(errorThrown, "Expected error to be thrown")
  }

  @Test("Web3TransactionBuilder passes correct parameters to invocation")
  func testWeb3TransactionBuilderPassesCorrectParametersToInvocation() throws {
    // Given
    let builder = Web3TransactionBuilder()

    // Create a custom transaction to verify parameters
    let expectedNonce = EthereumQuantity(quantity: 42)
    let expectedValue = EthereumQuantity(quantity: 2.eth)
    let expectedFees = Fees(
      maxFeePerGas: EthereumQuantity(quantity: 50.gwei),
      maxPriorityFeePerGas: EthereumQuantity(quantity: 2.gwei)
    )
    let expectedGasLimit = EthereumQuantity(quantity: 200_000)
    let expectedSender = EthereumAddress(
      hexString: "0xabcdef0123456789abcdef0123456789abcdef01"
    )!

    // Use a mock invocation that provides our expected values
    let mockInvocation = MockSolidityInvocation()

    // When
    let transaction = try builder.build(
      mockInvocation,
      sender: expectedSender,
      value: expectedValue,
      nonce: expectedNonce,
      prices: expectedFees,
      gasLimit: expectedGasLimit
    )

    // Then
    #expect(transaction.nonce == expectedNonce)
    #expect(transaction.maxFeePerGas == expectedFees.maxFeePerGas)
    #expect(transaction.maxPriorityFeePerGas == expectedFees.maxPriorityFeePerGas)
    #expect(transaction.gasLimit == expectedGasLimit)
    #expect(transaction.value == expectedValue)
    #expect(transaction.transactionType == .eip1559)
  }
}
