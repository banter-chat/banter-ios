// Web3ChatDataSource.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 1/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
// 

final class Web3ChatDataSource: RemoteChatDataSource {
  let web3: Web3Client
  let contract: ChatContract

  init(web3: Web3Client, contract: ChatContract) {
    self.web3 = web3
    self.contract = contract
  }
  
  func observeChats() -> AsyncStream<[Chat]> {
    AsyncStream { continuation in
      
    }
  }
}


