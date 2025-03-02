// Web3ResponseStatus+Result.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Web3

extension Web3Response.Status {
  var asResult: Swift.Result<StatusResult, Error> {
    switch self {
    case let .success(value): .success(value)
    case let .failure(error): .failure(error)
    }
  }
}
