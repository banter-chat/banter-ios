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
                Chat(id: "0x1", author: User(id: "user1", name: "Iban", photoColor: "", photoEmoji: ""), recipientId: "0x456", title: "Чат с Алисой"),
                Chat(id: "0x2", author: User(id: "0x123", name: "Iban", photoColor: "", photoEmoji: ""), recipientId: "user1", title: "Чат с Бобом"),
                Chat(id: "0x3", author: User(id: "user1", name: "Iban", photoColor: "", photoEmoji: ""), recipientId: "0x123", title: "Чат с Кэрол"),
                Chat(id: "0x4", author: User(id: "0x789", name: "Iban", photoColor: "", photoEmoji: ""), recipientId: "user1", title: "Чат с Дейвом"),
                Chat(id: "0x5", author: User(id: "user1", name: "Iban", photoColor: "", photoEmoji: ""), recipientId: "0xabc", title: "Чат с Евой"),
            ]
            continuation.yield(mockChats)
            continuation.finish()
        }
    }
}
