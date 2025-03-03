// ViewFactory.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 2/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

struct ViewFactory {
  func makeChatListView(onChatOpen: @escaping (String) -> Void) -> ChatListView {
    ChatListView(onChatOpen: onChatOpen)
  }

  func makeChatView(address: String) -> ChatView {
    ChatView(chatAddress: address)
  }
}
