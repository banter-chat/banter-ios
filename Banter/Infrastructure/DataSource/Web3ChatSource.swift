// Web3ChatSource.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 1/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Sharing
import Web3

struct Web3ChatSource: RemoteChatSource {
  let client: Web3Client
  let contractAddress: EthereumAddress
  let userAddress: EthereumAddress

  func observeChats() -> AsyncStream<[Chat]> {
    AsyncStream { continuation in
      let userId = userAddress.hex(eip55: true)

      Task {
        do {
          let existingDTOs = try await client.find(contractAddress: contractAddress,
                                                   event: ChatListContract.ChatCreated,
                                                   from: .earliest,
                                                   to: .latest)

          var chats = existingDTOs.compactMap(Chat.init).filter {
            $0.recipientId == userId || $0.authorId == userId
          }

          continuation.yield(chats)

          let updates = client.subscribe(contractAddress: contractAddress,
                                         event: ChatListContract.ChatCreated)

          for try await dto in updates {
            guard
              let newChat = Chat(dto: dto),
              newChat.recipientId == userId || newChat.authorId == userId
            else { continue }

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
    guard
      let chat = dto["chatContract"] as? EthereumAddress,
      let author = dto["author"] as? EthereumAddress,
      let recipient = dto["recipient"] as? EthereumAddress
    else { return nil }

    id = chat.hex(eip55: true)
    authorId = author.hex(eip55: true)
    recipientId = recipient.hex(eip55: true)
  }
}
