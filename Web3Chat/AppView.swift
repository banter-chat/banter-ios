// AppView.swift is a part of Web3Chat project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 19/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

struct AppView: View {
  var body: some View {
    NavigationStack {
      ChatListView()
    }
  }
}

#Preview {
  AppView()
}
