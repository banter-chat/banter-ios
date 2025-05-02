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
                Chat(id: "0x1", authorId: "user1", recipientId: "0x456", title: "Чат с Алисой"),
                Chat(id: "0x2", authorId: "0x123", recipientId: "user1", title: "Чат с Бобом"),
                Chat(id: "0x3", authorId: "user1", recipientId: "0x123", title: "Чат с Кэрол"),
                Chat(id: "0x4", authorId: "0x789", recipientId: "user1", title: "Чат с Дейвом"),
                Chat(id: "0x5", authorId: "user1", recipientId: "0xabc", title: "Чат с Евой"),
            ]
            continuation.yield(mockChats)
            continuation.finish()
        }
    }
}
