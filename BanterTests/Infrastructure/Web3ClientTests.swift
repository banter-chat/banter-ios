// Web3ClientTests.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import ConcurrencyExtras
import Foundation
import Testing
import Web3
import Web3ContractABI

@testable import Banter

@Suite("Web3Client Tests")
struct Web3ClientTests {

  @Test("BasicWeb3Client delegates call to web3 instance")
  func testBasicWeb3ClientCallDelegatesToWeb3() async throws {
    // Given
    let mockWeb3 = MockWeb3Async()
    mockWeb3.callResult = .success(["result": "success"])
    let client = BasicWeb3Client(web3: mockWeb3, chainId: 1)

    let mockInvocation = MockSolidityInvocation()

    // When
    let result = try await client.call(mockInvocation)

    // Then
    #expect(mockWeb3.callCalledWith is MockSolidityInvocation)
    #expect(result["result"] as? String == "success")
    #expect(result.count == 1)
  }

  @Test("BasicWeb3Client find returns decoded logs")
  func testBasicWeb3ClientFind() async throws {
    // Given
    let mockWeb3 = MockWeb3Async()
    mockWeb3.getLogsResult = .success([])

    let client = BasicWeb3Client(web3: mockWeb3, chainId: 1)

    let contractAddress = EthereumAddress(hexString: "0x1234567890123456789012345678901234567890")!
    let event = SolidityEvent(name: "event", anonymous: false, inputs: [])

    // When
    let logs = try await client.find(
      contractAddress: contractAddress,
      event: event,
      from: .earliest,
      to: .latest
    )

    // Then
    #expect(logs.count == 0)
    #expect(mockWeb3.getLogsCalledWith != nil)
    #expect(mockWeb3.getLogsCalledWith?.0 == [contractAddress])
    #expect(mockWeb3.getLogsCalledWith?.1 == nil)
    #expect(mockWeb3.getLogsCalledWith?.2 == .earliest)
    #expect(mockWeb3.getLogsCalledWith?.3 == .latest)
  }
}
