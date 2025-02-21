// Settings.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Sharing

extension SharedReaderKey
  where Self == AppStorageKey<String>.Default {
  static var rpcWSURL: Self {
    Self[.appStorage("rpcWSURL"), default: ""]
  }
}

extension SharedReaderKey
where Self == AppStorageKey<String>.Default {
  static var chainId: Self {
    Self[.appStorage("chainId"), default: ""]
  }
}

extension SharedReaderKey
  where Self == AppStorageKey<String>.Default {
  static var chatListAddress: Self {
    Self[.appStorage("chatListAddress"), default: ""]
  }
}

extension SharedReaderKey
  where Self == AppStorageKey<String>.Default {
  static var walletKeyHex: Self {
    Self[.appStorage("walletKeyHex"), default: ""]
  }
}
