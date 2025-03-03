// CoordinatedNavigationView.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 2/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

struct AppCoordinatorView: View {
  @State private var coordinator = AppCoordinator()
  let factory = ViewFactory()

  var body: some View {
    NavigationStack(path: $coordinator.path) {
      SettingsView { coordinator.openChatList() }
        .navigationDestination(for: Route.self) { route in
          switch route {
          case .chatList:
            factory.makeChatListView { coordinator.openChat(chatAddress: $0) }
          case let .chat(chatId):
            factory.makeChatView(address: chatId)
          }
        }
    }
  }
}
