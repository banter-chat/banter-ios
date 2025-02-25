// ChatView.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

struct ChatView: View {
  @State var isShowingAlert = false
  @State var model: ChatModel

  init(chatAddress: String) {
    _model = State(initialValue: ChatModel(chatAddress: chatAddress))
  }

  var body: some View {
    ZStack {
      if model.messages.isEmpty {
        Text("No Messages")
      } else {
        List(model.messages, id: \.self) { message in
          Text(message)
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
        }
        .rotationEffect(.radians(.pi))
        .scaleEffect(x: -1, y: 1, anchor: .center)
      }
    }
    .task {
      model.viewAppeared()
    }
    .toolbar {
      Button("Send Message") { isShowingAlert = true }
    }
    .alert("New Message", isPresented: $isShowingAlert) {
      TextField("Enter message", text: $model.newMessage)
      Button("Send", action: model.sendMessageTapped)
    } message: {
      Text("Provide a message for the recipient.")
    }
    .navigationTitle("Chat")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#if DEBUG
  #Preview {
    NavigationStack {
      ChatView(chatAddress: "")
    }
  }
#endif
