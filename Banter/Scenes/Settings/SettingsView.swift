// SettingsView.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

struct SettingsView: View {
  @AppStorage("rpcWSURL") var rpcWSURL = ""
  @AppStorage("chatListContract") var chatListContract = ""

  var body: some View {
    Form {
      Section("Settings") {
        TextField("WebSocket RPC URL", text: $rpcWSURL)
        TextField("Chat List Contract", text: $chatListContract)
      }

      NavigationLink(destination: ChatListView(rpcWSURL: rpcWSURL, contractAddress: chatListContract)) {
        Label("Chat List", systemImage: "message")
      }
      .disabled(rpcWSURL.isEmpty || chatListContract.isEmpty)
    }
  }
}

#Preview {
  NavigationStack {
    SettingsView()
  }
}
