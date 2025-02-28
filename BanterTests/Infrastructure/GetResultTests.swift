// GetResultTests.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Testing

@testable import Banter

@Suite("GetResult Tests")
struct GetResultTests {
  @Test("getResult with data returns success")
  func testGetResultWithDataReturnsSuccess() {
    // Given
    let testData = "Test data"
    let error: Error? = nil

    // When
    let result = getResult(testData, error)

    // Then
    #expect(result.isSuccess)
    if case .success(let data) = result {
      #expect(data == "Test data")
    }
  }

  @Test("getResult with error returns failure")
  func testGetResultWithErrorReturnsFailure() {
    // Given
    let testData: String? = nil
    struct TestError: Error {}
    let error: Error = TestError()

    // When
    let result = getResult(testData, error)

    // Then
    #expect(result.isFailure)
    if case .failure(let resultError) = result {
      #expect(resultError is TestError)
    }
  }

  @Test("getResult with both nil returns failure with both nil error")
  func testGetResultWithBothNilReturnsFailureWithBothNilError() {
    // Given
    let testData: String? = nil
    let error: Error? = nil

    // When
    let result = getResult(testData, error)

    // Then
    #expect(result.isFailure)
    if case .failure(let resultError) = result {
      #expect(resultError is GetResultError)
      #expect((resultError as? GetResultError) == .bothNil)
    }
  }

  @Test("getResult with both values prioritizes error")
  func testGetResultWithBothValuesPrioritizesError() {
    // Given
    let testData = "Test data"
    struct TestError: Error {}
    let error: Error = TestError()

    // When
    let result = getResult(testData, error)

    // Then
    #expect(result.isFailure)
    if case .failure(let resultError) = result {
      #expect(resultError is TestError)
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
