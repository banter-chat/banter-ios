// ChatListView.swift is a part of Web3Chat project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 19/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

struct ChatListView: View {
  @State var model = ChatListModel()

  var body: some View {
    List(model.chats) { chat in
      NavigationLink(chat.address, destination: ChatView())
    }
    .navigationTitle("Chats")
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
