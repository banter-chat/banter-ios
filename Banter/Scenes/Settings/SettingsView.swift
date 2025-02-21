// SettingsView.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

struct SettingsView: View {
  @State private var model = SettingsModel()

  var body: some View {
    Form {
      Section("Node settings") {
        TextField("WebSocket RPC URL", text: $model.rpcWSURL)
        TextField("Chat List Contract Address", text: $model.chatListAddress)
      }

      Section {
        if let address = model.walletAddress {
          Button {
            model.copyWalletAddressTapped()
          } label: {
            Label(address, systemImage: "doc.on.doc")
              .lineLimit(1)
          }
        }

        Button("Generate new") {
          model.generateNewAddressTapped()
        }
      } header: {
        Text("Wallet")
      } footer: {
        Text("Tap on address to copy")
      }

      Section {
        NavigationLink(destination: ChatListView()) {
          Label("Chat List", systemImage: "message")
        }
        .disabled(!model.isReadyToChat)
      } footer: {
        Text("Make sure to top up your balance")
      }
    }
    .navigationTitle("Banter Chat")
  }
}

#Preview {
  NavigationStack {
    SettingsView()
  }
}
