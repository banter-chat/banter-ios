import Foundation


extension MockChatRepository: ChatRepository{
    func observeChats() -> AsyncStream<[Chat]> {
        getChats()
    }
}


class MockChatRepository {
    func getChats() -> AsyncStream<[Chat]> {
        AsyncStream { continuation in
            let mockChats = [
                Chat(id: "0x1", author: User(id: "user1", name: "Iban", photoColor: "B4E2C0", photoEmoji: "☝️"), recipientId: "0x456", title: "Привет, как дела?"),
                Chat(id: "0x2", author: User(id: "user1", name: "aliceblue", photoColor: "B6DDFA", photoEmoji: "💀"), recipientId: "0x124", title: "Жду тебя у входа."),
                Chat(id: "0x3", author: User(id: "user1", name: "Iban", photoColor: "F5DDA1", photoEmoji: "☝️"), recipientId: "0x123", title: "Код работает отлично!")
            ]
            continuation.yield(mockChats)
            continuation.finish()
        }
    }
}
