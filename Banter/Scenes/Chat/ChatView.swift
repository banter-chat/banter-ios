// ChatView.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import SwiftUI

struct ChatView: View {
  var messages: [String] = ["Hello", "Hi", "How are you?"]
  var body: some View {
    List(messages, id: \.self) { message in
      Text(message)
        .rotationEffect(.radians(.pi))
        .scaleEffect(x: -1, y: 1, anchor: .center)
    }
    .rotationEffect(.radians(.pi))
    .scaleEffect(x: -1, y: 1, anchor: .center)
  }
}

#if DEBUG
  #Preview {
    NavigationStack {
      ChatView()
    }
  }
#endif
