// Web3SourceFactory.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 1/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Foundation
import Web3

extension Web3SourceFactory: RemoteChatSourceFactory {
  func makeChatSource(with settings: UserSettings) throws -> RemoteChatSource {
    let contract = try EthereumAddress(hex: settings.web3.contractAddress, eip55: false)
    let user = try EthereumAddress(hex: settings.web3.userAddress, eip55: false)
    let client = try makeClient(with: settings)
    return Web3ChatSource(client: client, contractAddress: contract, userAddress: user)
  }
}

extension Web3SourceFactory {
  func makeMessageSource(
    with settings: UserSettings, chatAddress: String
  ) throws -> RemoteChatMessageSource {
    let contract = try EthereumAddress(hex: chatAddress, eip55: false)
    let client = try makeClient(with: settings)
    return Web3ChatMessageSource(web3Client: client, chatAddress: contract)
  }
}

struct Web3SourceFactory {
  private func makeClient(with settings: UserSettings) throws -> Web3Client {
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

    let web3 = try Web3(wsUrl: url.absoluteString)

    let adapter = Web3AsyncAdapter(web3: web3)
    return BasicWeb3Client(web3: adapter, chainId: chainId)
  }
}

enum Web3ChatSourceFactoryError: Error {
  case invalidChainId
  case invalidURL
}
