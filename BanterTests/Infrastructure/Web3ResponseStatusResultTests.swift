// Web3ResponseStatusResultTests.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Testing
import Web3

@testable import Banter

@Suite("Web3ResponseStatusResult Tests")
struct Web3ResponseStatusResultTests {
  @Test("asResult with success returns success")
  func testAsResultWithSuccessReturnsSuccess() {
    // Given
    let expectedValue = "Test value"
    let status = Web3Response<String>.Status.success(expectedValue)

    // When
    let result = status.asResult

    // Then
    #expect(result.isSuccess)
    if case .success(let value) = result {
      #expect(value == expectedValue)
    }
  }

  @Test("asResult with failure returns failure")
  func testAsResultWithFailureReturnsFailure() {
    // Given
    struct TestError: Error {}
    let expectedError = TestError()
    let status = Web3Response<String>.Status<TestError>.failure(expectedError)

    // When
    let result = status.asResult

    // Then
    #expect(result.isFailure)
    if case .failure(let error) = result {
      #expect(error is TestError)
    }
  }
}

// MARK: - Helper Extensions for Testing
extension Result {
  fileprivate var isSuccess: Bool {
    switch self {
    case .success: return true
    case .failure: return false
    }
  }

  fileprivate var isFailure: Bool {
    return !isSuccess
  }
}
