// Web3ChatSource.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 1/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Sharing
import Web3

struct Web3ChatSource: RemoteChatDataSource {
  let client: Web3Client
  let contractAddress: EthereumAddress

  func observeChats() -> AsyncStream<[Chat]> {
    AsyncStream { continuation in
      Task {
        do {
          let existingDTOs = try await client.find(contractAddress: contractAddress,
                                                   event: ChatListContract.ChatCreated,
                                                   from: .earliest,
                                                   to: .latest)

          var chats = existingDTOs.compactMap(Chat.init)

          continuation.yield(chats)

          let updates = client.subscribe(contractAddress: contractAddress,
                                         event: ChatListContract.ChatCreated)

          for try await dto in updates {
            guard let newChat = Chat(dto: dto) else { continue }
            chats.append(newChat)
            continuation.yield(chats)
          }
        } catch {
          continuation.finish()
        }
      }
    }
  }
}

private extension Chat {
  init?(dto: [String: Any]) {
    guard let chat = dto["chatContract"] as? EthereumAddress else { return nil }
    self.id = chat.hex(eip55: true)
  }
}

//
// web3.eth.getLogs(addresses: [contractAddress],
//                 topics: nil,
//                 fromBlock: .earliest,
//                 toBlock: .latest) { resp in
//  guard let logs = resp.result else { return }
//  for log in logs {
//    processChatEvent(caller: caller, log: log, onNewChat: onNewChat)
//  }
// }
//
// try! web3.eth.subscribeToLogs(addresses: [contractAddress]) { _ in
//  print("subscribed")
// } onEvent: { resp in
//  guard let log = resp.result else { return }
//  processChatEvent(caller: caller, log: log, onNewChat: onNewChat)
// }
// }
//
// func processChatEvent(
//  caller: EthereumAddress, log: EthereumLogObject, onNewChat: @escaping (String) -> Void
// ) {
//  guard
//    let event = try? ABI.decodeLog(event: ChatListContract.ChatCreated, from: log),
//    let author = event["author"] as? EthereumAddress,
//    let recipient = event["recipient"] as? EthereumAddress,
//    let chat = event["chatContract"] as? EthereumAddress,
//    author == caller || recipient == caller
//  else { return }
//
//  onNewChat(chat.hex(eip55: true))
// }
