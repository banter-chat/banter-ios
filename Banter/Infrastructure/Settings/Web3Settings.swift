// Web3Settings.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 1/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Sharing

struct Web3Settings: Codable {
  var rpcWSURL = ""
  var chainId = ""
  var contractAddress = ""
}

struct UserSettings: Codable {
  var web3 = Web3Settings()
}

extension SharedReaderKey
  where Self == FileStorageKey<UserSettings>.Default {
  static var userSettings: Self {
    Self[.fileStorage(.userSettings), default: UserSettings()]
  }
}

extension URL {
  static let userSettings = Self.documentsDirectory
    .appendingPathComponent("user-settings")
    .appendingPathExtension("json")
}

