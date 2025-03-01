// Web3ChatSourceFactory.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 1/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Web3

struct Web3ChatSourceFactory: RemoteChatDataSourceFactory {
  func makeDataSource(with settings: UserSettings) throws -> RemoteChatDataSource {
    guard
      let chainId = UInt64(settings.web3.chainId)
    else {
      throw Web3ChatSourceFactoryError.invalidChainId
    }

    guard
      let url = URL(string: settings.web3.rpcWSURL),
      url.scheme == "wss", url.host() != nil
    else {
      throw Web3ChatSourceFactoryError.invalidURL
    }

    let address = try EthereumAddress(hex: settings.web3.contractAddress, eip55: false)
    let web3 = try Web3(wsUrl: url.absoluteString)

    let adapter = Web3AsyncAdapter(web3: web3)
    let client = BasicWeb3Client(web3: adapter, chainId: chainId)

    return Web3ChatSource(client: client, contractAddress: address)
  }
}

enum Web3ChatSourceFactoryError: Error {
  case invalidChainId
  case invalidURL
}
