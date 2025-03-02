// Web3Async.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 2/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Web3
import Web3ContractABI

/// A protocol that provides asynchronous access to Ethereum blockchain functionality.
///
/// `Web3Async` offers methods to interact with an Ethereum node using Swift's modern async/await pattern,
/// allowing for more readable and maintainable blockchain interaction code.
///
/// - Important: All methods in this protocol are designed to be called with Swift's `async`/`await` syntax
///   and may throw errors related to network connectivity, JSON parsing, or blockchain-specific issues.
protocol Web3Async {
  /// Retrieves the number of transactions sent from an Ethereum address.
  ///
  /// Use this method to get the current nonce for an account, which is required when creating new transactions.
  ///
  /// - Parameters:
  ///   - address: The Ethereum address to check
  ///   - block: The block state to query (latest, earliest, pending, or specific block number)
  /// - Returns: The number of transactions sent from the address as an `EthereumQuantity`
  /// - Throws: An error if the request fails or the response cannot be parsed
  func getTransactionCount(
    for address: EthereumAddress, block: EthereumQuantityTag
  ) async throws -> EthereumQuantity

  /// Gets the current gas price on the network.
  ///
  /// This method returns the current gas price in wei, which can be used to estimate
  /// transaction costs or set appropriate gas prices for new transactions.
  ///
  /// - Returns: The current gas price as an `EthereumQuantity`
  /// - Throws: An error if the request fails or the response cannot be parsed
  func gasPrice() async throws -> EthereumQuantity

  /// Estimates the gas required to execute a contract method invocation.
  ///
  /// Use this method before sending a transaction to estimate how much gas will be consumed.
  /// The estimate may not be exact but provides a reasonable upper bound.
  ///
  /// - Parameters:
  ///   - invocation: The contract method invocation to estimate
  ///   - from: The optional Ethereum address that would send the transaction
  ///   - gas: An optional gas limit to use for the estimation
  ///   - value: An optional amount of ether to send with the transaction
  /// - Returns: The estimated gas as an `EthereumQuantity`
  /// - Throws: An error if the estimation fails, which might indicate the transaction would revert
  func estimateGas(
    invocation: SolidityInvocation,
    from: EthereumAddress?,
    gas: EthereumQuantity?,
    value: EthereumQuantity?
  ) async throws -> EthereumQuantity

  /// Executes a contract method call without creating a transaction on the blockchain.
  ///
  /// This method is useful for reading data from smart contracts without spending gas or
  /// changing the blockchain state.
  ///
  /// - Parameter invocation: The contract method invocation to execute
  /// - Returns: The result of the call as a dictionary, which must be decoded based on the expected return types
  /// - Throws: An error if the call fails or the response cannot be parsed
  func call(_ invocation: SolidityInvocation) async throws -> [String: Any]

  /// Sends a signed transaction to the blockchain.
  ///
  /// Use this method to broadcast already-signed transactions to the Ethereum network.
  ///
  /// - Parameter transaction: The signed transaction to send
  /// - Returns: The transaction hash as `EthereumData`
  /// - Throws: An error if the transaction couldn't be sent or was rejected by the network
  func sendRawTransaction(
    transaction: EthereumSignedTransaction
  ) async throws -> EthereumData

  /// Retrieves logs that match the specified filter criteria.
  ///
  /// This method allows querying the blockchain for events emitted by smart contracts
  /// within a specified block range.
  ///
  /// - Parameters:
  ///   - addresses: Optional array of contract addresses to filter logs
  ///   - topics: Optional array of topic arrays to filter logs (supports complex topic matching)
  ///   - fromBlock: The starting block for the filter
  ///   - toBlock: The ending block for the filter
  /// - Returns: An array of log objects matching the filter criteria
  /// - Throws: An error if the request fails or the response cannot be parsed
  func getLogs(
    addresses: [EthereumAddress]?,
    topics: [[EthereumData]]?,
    fromBlock: EthereumQuantityTag,
    toBlock: EthereumQuantityTag
  ) async throws -> [EthereumLogObject]

  /// Creates an asynchronous stream of log events that match the specified filter criteria.
  ///
  /// Use this method to subscribe to real-time event logs from smart contracts. The stream
  /// will continue to emit new log objects as they are created on the blockchain.
  ///
  /// - Parameters:
  ///   - addresses: Optional array of contract addresses to filter logs
  ///   - topics: Optional array of topic arrays to filter logs (supports complex topic matching)
  /// - Returns: An `AsyncThrowingStream` that emits log objects as they are received
  func subscribeToLogs(
    addresses: [EthereumAddress]?, topics: [[EthereumData]]?
  ) -> AsyncThrowingStream<EthereumLogObject, Error>
}

/// Extension providing default parameter values for `Web3Async` methods.
extension Web3Async {
  /// Retrieves the number of transactions sent from an Ethereum address.
  ///
  /// This version uses the latest block state by default.
  ///
  /// - Parameters:
  ///   - address: The Ethereum address to check
  ///   - block: The block state to query (defaults to `.latest`)
  /// - Returns: The number of transactions sent from the address as an `EthereumQuantity`
  /// - Throws: An error if the request fails or the response cannot be parsed
  func getTransactionCount(
    for address: EthereumAddress, block: EthereumQuantityTag = .latest
  ) async throws -> EthereumQuantity {
    try await getTransactionCount(for: address, block: block)
  }

  /// Estimates the gas required to execute a contract method invocation.
  ///
  /// This version provides default values for optional parameters.
  ///
  /// - Parameters:
  ///   - invocation: The contract method invocation to estimate
  ///   - from: The optional Ethereum address that would send the transaction (defaults to `nil`)
  ///   - gas: An optional gas limit to use for the estimation (defaults to `nil`)
  ///   - value: An optional amount of ether to send with the transaction (defaults to `nil`)
  /// - Returns: The estimated gas as an `EthereumQuantity`
  /// - Throws: An error if the estimation fails, which might indicate the transaction would revert
  func estimateGas(
    invocation: SolidityInvocation,
    from: EthereumAddress? = nil,
    gas: EthereumQuantity? = nil,
    value: EthereumQuantity? = nil
  ) async throws -> EthereumQuantity {
    try await estimateGas(invocation: invocation,
                          from: from,
                          gas: gas,
                          value: value)
  }

  /// Retrieves logs that match the specified filter criteria.
  ///
  /// This version provides default values for optional parameters, making it easier
  /// to query only the latest block if desired.
  ///
  /// - Parameters:
  ///   - addresses: Optional array of contract addresses to filter logs (defaults to `nil`)
  ///   - topics: Optional array of topic arrays to filter logs (defaults to `nil`)
  ///   - fromBlock: The starting block for the filter (defaults to `.latest`)
  ///   - toBlock: The ending block for the filter (defaults to `.latest`)
  /// - Returns: An array of log objects matching the filter criteria
  /// - Throws: An error if the request fails or the response cannot be parsed
  func getLogs(
    addresses: [EthereumAddress]? = nil,
    topics: [[EthereumData]]? = nil,
    fromBlock: EthereumQuantityTag = .latest,
    toBlock: EthereumQuantityTag = .latest
  ) async throws -> [EthereumLogObject] {
    try await getLogs(addresses: addresses,
                      topics: topics,
                      fromBlock: fromBlock,
                      toBlock: toBlock)
  }

  /// Creates an asynchronous stream of log events that match the specified filter criteria.
  ///
  /// This version provides default values for optional parameters.
  ///
  /// - Parameters:
  ///   - addresses: Optional array of contract addresses to filter logs (defaults to `nil`)
  ///   - topics: Optional array of topic arrays to filter logs (defaults to `nil`)
  /// - Returns: An `AsyncThrowingStream` that emits log objects as they are received
  func subscribeToLogs(
    addresses: [EthereumAddress]? = nil,
    topics: [[EthereumData]]? = nil
  ) -> AsyncThrowingStream<EthereumLogObject, Error> {
    subscribeToLogs(addresses: addresses, topics: topics)
  }
}
