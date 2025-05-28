//error nil

import SwiftUI
struct ChatItemView: View {
    var chatItem: Chat
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8){
                ZStack{
                    Circle()
                        .fill(Color(hex: chatItem.author.photoColor))
                        .frame(width: 60, height: 60)
                    Text(chatItem.author.photoEmoji)
                        .font(.system(size: 22))
                }
                VStack(alignment: .leading, spacing: 3){
                    Text(chatItem.author.name)
                        .font(font: .black, size: 18)
                        .foregroundStyle(.white)
                    Text(chatItem.title ?? "")
                        .font(font: .regular)
                        .foregroundStyle(.white)
                }
            }
            Spacer()
            VStack(spacing: 9){
                Text("12:31")
                    .font(font: .black, size: 13)
                    .foregroundStyle(.white)
                Circle()
                    .fill(.appPurple)
                    .frame(width: 14, height: 14)
            }
        }
        .padding(20)
        .background(.appSecond)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
