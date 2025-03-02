// AsyncWrapper.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

func asyncWrapper<T>(
  _ workload: @escaping (@escaping (T) -> Void) -> Void
) async -> T {
  await withCheckedContinuation { continuation in
    workload { continuation.resume(returning: $0) }
  }
}

func throwingAsyncWrapper<T>(
  _ workload: @escaping (@escaping (T) -> Void) throws -> Void
) async throws -> T {
  try await withCheckedThrowingContinuation { continuation in
    do {
      try workload { continuation.resume(returning: $0) }
    } catch {
      continuation.resume(throwing: error)
    }
  }
}
