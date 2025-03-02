// AppCoordinator.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 2/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

enum Route: Hashable {
  case chat(chatAddress: String)
  case chatList
}

@Observable
final class AppCoordinator {
  var path = NavigationPath()

  func goBack() {
    path.removeLast()
  }

  func openChatList() {
    path.append(Route.chatList)
  }

  func openChat(chatAddress: String) {
    path.append(Route.chat(chatAddress: chatAddress))
  }

  func goToRoot() {
    path.removeLast(path.count)
  }
}
