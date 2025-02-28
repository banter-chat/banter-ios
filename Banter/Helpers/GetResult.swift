// GetResult.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 27/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation

func getResult<T>(_ data: T?, _ error: Error?) -> Result<T, Error> {
  if let error {
    .failure(error)
  } else if let data {
    .success(data)
  } else {
    .failure(
      NSError(
        domain: "SwiftResultConversionError", code: -1,
        userInfo: [NSLocalizedDescriptionKey: "Both result and error were nil"]
      )
    )
  }
}
