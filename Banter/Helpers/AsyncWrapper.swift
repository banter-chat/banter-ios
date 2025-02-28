// AsyncWrapper.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

// Original callback-based function type
typealias Completion<T> = (Result<T, Error>) -> Void

// Wrapper that converts to async/throws
@discardableResult
func asyncWrapper<T>(
  _ workload: @escaping (@escaping Completion<T>) throws -> Void
) async throws -> T {
  try await withCheckedThrowingContinuation { continuation in
    do {
      try workload { result in
        switch result {
        case let .success(value):
          continuation.resume(returning: value)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    } catch {
      continuation.resume(throwing: error)
    }
  }
}
