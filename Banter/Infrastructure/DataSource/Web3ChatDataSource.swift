// Web3ChatDataSource.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 1/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
// 

import Sharing

final class Web3ChatDataSource: RemoteChatDataSource {
  @Shared(.userSettings) var settings


  func observeChats() -> AsyncStream<[Chat]> {
    AsyncStream { continuation in
      
    }
  }
}


