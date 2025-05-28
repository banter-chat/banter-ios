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

  let onChatOpen: (String) -> Void

  var body: some View {
      ZStack(alignment: .top){
          HStack{
              Text("Bunter")
                  .foregroundStyle(.white)
                  .font(font: .bold, size: 23)
              Spacer()
              HStack(spacing: 15){
                  Button {
                      //
                  } label: {
                      Image(systemName: "magnifyingglass")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 14, height: 14)
                          .padding(10)
                          .background(.appSecond)
                          .clipShape(Circle())
                          .foregroundStyle(.white)
                  }
                  
                  Button {
                      //
                  } label: {
                      Image(systemName: "pencil")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 14, height: 14)
                          .padding(10)
                          .background(.appSecond)
                          .clipShape(Circle())
                          .foregroundStyle(.white)
                  }


              }
          }
          .padding(.bottom, 10)
          .background(.appBG)
          .zIndex(1)
          ScrollView{
              VStack(alignment: .leading, spacing: 25){
                  
              }
              .padding(.top, 45)
              
          }
      }
      .padding(.horizontal, 20)
      .background(.appBG)
    .task {
      await model.viewAppeared()
    }
  }
}

#if DEBUG
  #Preview {
    NavigationStack {
      ChatListView(onChatOpen: { _ in })
    }
  }
#endif


