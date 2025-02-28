// GetResult.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

func getResult<T>(_ data: T?, _ error: Error?) -> Swift.Result<T, Error> {
  if let error {
    .failure(error)
  } else if let data {
    .success(data)
  } else {
    .failure(GetResultError.bothNil)
  }
}

enum GetResultError: Error {
  case bothNil
}
