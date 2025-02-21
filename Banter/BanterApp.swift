// BanterApp.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

@main
struct BanterApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        ChatListView()
      }
    }
  }
}
