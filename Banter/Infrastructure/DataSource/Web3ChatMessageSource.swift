// Web3ChatMessageSource.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 2/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import ConcurrencyExtras
import Foundation
import Web3

struct Web3ChatMessageSource: RemoteChatMessageSource {
  private let web3Client: Web3Client
  private let chatAddress: EthereumAddress

  init(web3Client: Web3Client, chatAddress: EthereumAddress) {
    self.web3Client = web3Client
    self.chatAddress = chatAddress
  }

  func getAllMessages() async throws -> [ChatMessage] {
    // Fetch all logs from the chat contract
    let events = try await web3Client.find(
      contractAddress: chatAddress,
      event: ChatContract.MessageSent,
      from: .earliest,
      to: .latest
    )

    // Convert logs to ChatMessage objects
    let messages = events.compactMap(ChatMessage.init)

    // Sort messages by timestamp (newest first)
    return messages.sorted { $0.timestamp > $1.timestamp }
  }

  func observeUpdates() -> AsyncStream<ChatMessageUpdate> {
    let stream = web3Client.subscribe(
      contractAddress: chatAddress,
      event: ChatContract.MessageSent
    )
    .compactMap { dto -> ChatMessageUpdate? in
      guard let newMessage = ChatMessage(dto: dto) else { return nil }
      return ChatMessageUpdate.added(message: newMessage)
    }

    return UncheckedSendable(stream).eraseToStream()
  }
}

private extension ChatMessage {
  init?(dto: [String: Any]) {
    guard
      let sender = dto["sender"] as? EthereumAddress,
      let message = dto["message"] as? String,
      let timestampBigInt = dto["timestamp"] as? BigUInt
    else {
      return nil
    }

    // Convert timestamp from uint256 to Date
    let timestampDouble = Double(timestampBigInt)
    let date = Date(timeIntervalSince1970: timestampDouble)

    self.id = UUID().uuidString // Generate a unique ID for the message
    self.senderId = sender.hex(eip55: false)
    self.content = message
    self.timestamp = date
  }
}
