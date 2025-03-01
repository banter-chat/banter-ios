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
  var chatListAddress = ""
}

extension SharedReaderKey
  where Self == FileStorageKey<Web3Settings>.Default {
  static var web3Settings: Self {
    Self[.fileStorage(.web3Settings), default: Web3Settings()]
  }
}

extension URL {
  static let web3Settings = Self.documentsDirectory
    .appendingPathComponent("web3-settings")
    .appendingPathExtension("json")
}

