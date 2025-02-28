// AsyncWrapperTests.swift is a part of Banter project
//
// Created by AI Assistant, 28/5/24
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Testing

@testable import Banter

@Suite("AsyncWrapper Tests")
struct AsyncWrapperTests {

  @Test("asyncWrapper completes with value from async operation")
  func testAsyncWrapper() async throws {
    // Given
    let expectedValue = "Success"

    // When
    let result = await asyncWrapper { completion in
      // Simulate async operation
      DispatchQueue.global().async {
        completion(expectedValue)
      }
    }

    // Then
    #expect(result == expectedValue)
  }

  @Test("asyncWrapper completes with immediate return value")
  func testAsyncWrapperWithImmediateReturn() async throws {
    // Given
    let expectedValue = 42

    // When
    let result = await asyncWrapper { completion in
      // Immediate completion
      completion(expectedValue)
    }

    // Then
    #expect(result == expectedValue)
  }

  @Test("throwingAsyncWrapper completes successfully with value")
  func testThrowingAsyncWrapper_Success() async throws {
    // Given
    let expectedValue = [1, 2, 3]

    // When
    let result = try await throwingAsyncWrapper { completion in
      // Simulate successful async operation
      DispatchQueue.global().async {
        completion(expectedValue)
      }
    }

    // Then
    #expect(result == expectedValue)
  }

  @Test("throwingAsyncWrapper propagates thrown errors")
  func testThrowingAsyncWrapper_Error() async throws {
    // Given
    enum TestError: Error {
      case someError
    }

    // When/Then
    var errorWasThrown = false

    do {
      _ = try await throwingAsyncWrapper { (completion: (String) -> Void) in
        throw TestError.someError
      }
    } catch is TestError {
      errorWasThrown = true
    }

    #expect(errorWasThrown, "Expected TestError to be thrown")
  }

  @Test("throwingAsyncWrapper works with delayed completion")
  func testThrowingAsyncWrapper_WithDelay() async throws {
    // Given
    let expectedValue = "Delayed success"

    // When
    let result = try await throwingAsyncWrapper { completion in
      // Simulate delayed async operation
      DispatchQueue.global().asyncAfter(deadline: .now() + 0.01) {
        completion(expectedValue)
      }
    }

    // Then
    #expect(result == expectedValue)
  }
}
