// ChatListView.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 19/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

struct ChatListView: View {
  @State var isShowingAlert = false
  @State var model = ChatListModel()

  var body: some View {
    Form {
      Section {
        if let address = model.walletAddress {
          Button {
            model.copyWalletAddressTapped()
          } label: {
            Label(address, systemImage: "doc.on.doc")
              .lineLimit(1)
          }
        }
      } header: {
        Text("Your address")
      } footer: {
        Text("Tap to copy")
      }

      Section("Conversations") {
        ForEach(model.chats) { chat in
          NavigationLink(
            chat.title ?? chat.id,
            destination: ChatView(chatAddress: chat.id) //ChatViewPld(chatAddress: chat.id) //ChatView(model: ChatModel(chatAddress: chat.id))
          )
          .lineLimit(1)
        }
      }
    }
    .navigationTitle("Chats")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      Button("Create chat") { isShowingAlert = true }
    }
    .alert("New Chat", isPresented: $isShowingAlert) {
      TextField("Enter address", text: $model.newChatAddress)
      Button("Create", action: model.createNewChat)
    } message: {
      Text("Provide an address of the recipient.")
    }
    .task {
      model.viewAppeared()
    }
  }
}

#if DEBUG
  #Preview {
    NavigationStack {
      ChatListView()
    }
  }
#endif
