# Message Additions: Implementation Approach

## 1. Introduction

This document describes the selected approach for receiving new message additions in a chat application, following clean architecture principles. It builds upon the previously defined timestamp-based pagination method for initial message retrieval, focusing specifically on how to handle real-time additions efficiently, with an extensible design for future enhancements.

## 2. Scope

This document focuses specifically on:
- Methods for receiving real-time message additions
- Integration with the existing message retrieval mechanism
- Extensible design for future update types
- Comparison of implementation approaches

## 3. Goals

- Design an efficient mechanism for receiving message additions
- Create an extensible architecture that can be expanded later
- Ensure a clean separation between domain and implementation layers
- Support reactive UI updates based on message stream
- Adhere to clean architecture principles
- Ensure testability and maintainability

## 4. Non-goals

- Initial message retrieval (already defined using timestamp-based pagination)
- Additional convenience methods for message retrieval
- Network layer implementation details
- UI implementation details
- Message storage/caching (may be addressed separately)
- Message editing/deletion implementation (mentioned only as future expansion)

## 5. Starting Point

We have already established a message repository with timestamp-based pagination for initial message retrieval:

```swift
protocol MessageRepository {
    // Retrieve messages with pagination
    func getMessages(chatId: String, before: Date?, limit: Int) async throws -> [Message]
    
    // Method for message updates to be defined...
}
```

## 6. Selected Approach: AsyncStream for Message Additions

After evaluating different options, we have selected the AsyncStream approach for receiving new message additions, with an extensible design that can accommodate other update types in the future.

### 6.1 Protocol Definition

```swift
// Simple version focused on additions only, but extensible for future enhancements
enum MessageUpdate {
    case added(message: Message)
    // Future expansion:
    // case edited(message: Message)
    // case deleted(messageId: String)
    // case statusChanged(messageId: String, status: MessageStatus)
}

protocol MessageRepository {
    // Existing method for message retrieval
    func getMessages(chatId: String, before: Date?, limit: Int) async throws -> [Message]
    
    // New method for observing message additions
    func observeMessageUpdates(chatId: String) -> AsyncStream<MessageUpdate>
    
    // Message sending
    func sendMessage(chatId: String, content: String) async throws -> Message
}
```

### 6.2 Implementation Details

```swift
class MessageRepositoryImpl: MessageRepository {
    private let dataSource: MessageDataSource
    
    init(dataSource: MessageDataSource) {
        self.dataSource = dataSource
    }
    
    // Existing message retrieval methods...
    
    func observeMessageUpdates(chatId: String) -> AsyncStream<MessageUpdate> {
        return AsyncStream { continuation in
            // Set up subscription to the data source
            let subscription = dataSource.subscribeToMessageUpdates(chatId: chatId) { event in
                switch event {
                    case .messageAdded(let message):
                        continuation.yield(.added(message: message))
                    // Future cases can be added here
                }
            }
            
            // Clean up when the stream is terminated
            continuation.onTermination = { _ in
                subscription.cancel()
            }
        }
    }
    
    func sendMessage(chatId: String, content: String) async throws -> Message {
        // Send the message through the data source
        let sentMessage = try await dataSource.sendMessage(
            chatId: chatId,
            content: content
        )
        
        return sentMessage
        
        // Note: The message will also arrive through the update stream
        // This allows other clients to receive the message
    }
}
```

### 6.3 Advantages of This Approach

- **Reactive data flow**: Provides a stream of updates as messages are added
- **Clean abstractions**: Separates domain logic from implementation details
- **Type safety**: Uses a strongly-typed enum to represent updates
- **Simple but extensible**: Starts with a focused implementation that can grow
- **Concurrency-friendly**: Works well with Swift's structured concurrency
- **Testable**: Easy to mock for unit testing

### 6.4 Disadvantages of This Approach

- **Stream management**: Requires careful handling of the AsyncStream lifecycle
- **More complex than direct callbacks**: Has a steeper learning curve than simpler patterns
- **Error handling**: Needs consideration for error propagation in streams
- **Testing complexity**: Requires proper testing of asynchronous streams
- **Implementation complexity**: Data sources must support the required subscription patterns

### 6.5 Usage Example with SwiftUI

```swift
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoadingMore = false
    
    private let messageRepository: MessageRepository
    private let chatId: String
    private var oldestMessageDate: Date?
    private var updateTask: Task<Void, Never>?
    
    init(chatId: String, messageRepository: MessageRepository = MessageRepositoryImpl()) {
        self.chatId = chatId
        self.messageRepository = messageRepository
    }
    
    func loadInitialMessages() async {
        do {
            let initialMessages = try await messageRepository.getMessages(
                chatId: chatId,
                before: nil,
                limit: 30
            )
            
            await MainActor.run {
                self.messages = initialMessages.sorted(by: { $0.timestamp < $1.timestamp })
                self.oldestMessageDate = initialMessages.map { $0.timestamp }.min()
            }
            
            // Start observing updates
            startObservingUpdates()
        } catch {
            // Handle error
        }
    }
    
    private func startObservingUpdates() {
        updateTask = Task {
            for await update in messageRepository.observeMessageUpdates(chatId: chatId) {
                await MainActor.run {
                    applyUpdate(update)
                }
            }
        }
    }
    
    private func applyUpdate(_ update: MessageUpdate) {
        switch update {
        case .added(let message):
            // Check if the message already exists (to handle potential duplicates)
            if !messages.contains(where: { $0.id == message.id }) {
                messages.append(message)
                messages.sort(by: { $0.timestamp < $1.timestamp })
            }
            // Future cases can be added here as the enum expands
        }
    }
    
    func loadMoreMessages() async {
        guard let oldestDate = oldestMessageDate, !isLoadingMore else { return }
        
        await MainActor.run {
            isLoadingMore = true
        }
        
        do {
            let olderMessages = try await messageRepository.getMessages(
                chatId: chatId,
                before: oldestDate,
                limit: 30
            )
            
            await MainActor.run {
                if !olderMessages.isEmpty {
                    let sortedMessages = olderMessages.sorted(by: { $0.timestamp < $1.timestamp })
                    self.messages.insert(contentsOf: sortedMessages, at: 0)
                    self.oldestMessageDate = sortedMessages.map { $0.timestamp }.min()
                }
                isLoadingMore = false
            }
        } catch {
            await MainActor.run {
                isLoadingMore = false
            }
            // Handle error
        }
    }
    
    func sendMessage(content: String) async {
        do {
            _ = try await messageRepository.sendMessage(
                chatId: chatId,
                content: content
            )
            // The message will come through the update stream
        } catch {
            // Handle error
        }
    }
    
    deinit {
        updateTask?.cancel()
    }
}
```

## 7. Alternatives Considered

We evaluated several alternative approaches before selecting AsyncStream for Message Additions. Each had its own advantages and trade-offs:

### 7.1. Option A: Polling for New Messages

This approach periodically checks for messages newer than the most recent message.

```swift
protocol MessageRepository {
    func getMessages(chatId: String, after: Date, limit: Int) async throws -> [Message]
    
    // No specific update method, just repeated calls to check for new messages
}
```

**Advantages:**
- Simple implementation
- No need for complex subscription mechanisms
- Works with any data source implementation
- Easy to understand and reason about
- Low implementation complexity

**Disadvantages:**
- Not reactive by design
- Requires client to implement polling logic
- Less efficient for real-time requirements
- May miss updates between polling intervals
- Not aligned with modern reactive patterns

**Reason for not selecting:** This approach doesn't provide a reactive way to receive updates and requires the client to implement polling logic, which is less elegant than a push-based solution.

### 7.2. Option B: Callback-Based Updates

This approach uses callbacks to notify about new messages.

```swift
protocol MessageRepository {
    func startObservingMessages(chatId: String, onNewMessage: @escaping (Message) -> Void) -> Cancellable
}
```

**Advantages:**
- Familiar pattern for many developers
- Simple to understand
- Works well with older codebases
- No dependency on newer Swift features

**Disadvantages:**
- Can lead to callback hell
- Harder to maintain complex update logic
- Manual cancellation management required
- Less integration with Swift's structured concurrency

**Reason for not selecting:** While callbacks are familiar, they don't integrate as well with modern Swift concurrency features and can lead to more complex code organization.

### 7.3. Option C: Combine Publishers

This approach uses Combine to publish message updates.

```swift
protocol MessageRepository {
    func observeNewMessages(chatId: String) -> AnyPublisher<Message, Error>
}
```

**Advantages:**
- Integration with Combine ecosystem
- Supports reactive programming patterns
- Robust error handling
- Rich set of operators for transforming data

**Disadvantages:**
- Dependency on the Combine framework
- Higher learning curve
- Added complexity for simple use cases
- Requires explicit cancellation management

**Reason for not selecting:** While Combine offers powerful reactive programming capabilities, the AsyncStream approach provides similar functionality with better integration with Swift's structured concurrency and less cognitive overhead.

## 8. Future Extensions

The current implementation focuses on message additions, but the design is extensible for future enhancements:

### 8.1. Message Editing

```swift
// Protocol extension
extension MessageRepository {
    func editMessage(messageId: String, newContent: String) async throws -> Message
}

// Update enum extension
extension MessageUpdate {
    case edited(message: Message)
}
```

### 8.2. Message Deletion

```swift
// Protocol extension
extension MessageRepository {
    func deleteMessage(messageId: String) async throws
}

// Update enum extension
extension MessageUpdate {
    case deleted(messageId: String)
}
```

### 8.3. Message Status Updates

```swift
enum MessageStatus {
    case sending
    case sent
    case delivered
    case read
    case failed(error: Error?)
}

// Protocol extension
extension MessageRepository {
    func markMessageAsRead(messageId: String) async throws
}

// Update enum extension
extension MessageUpdate {
    case statusChanged(messageId: String, status: MessageStatus)
}
```

## 9. Implementation Considerations

When implementing the MessageRepository, consider the following aspects:

1. **Data source abstraction**: Create a proper abstraction for the underlying data source
2. **Error propagation**: Define how errors from the data source are propagated to clients
3. **Thread safety**: Ensure thread-safe access to shared resources
4. **Resource management**: Properly manage subscriptions to avoid memory leaks
5. **Testing approach**: Use dependency injection to facilitate testing with mock data sources

## 10. Conclusion

The AsyncStream approach for message additions provides a clean, reactive solution that meets the immediate needs while remaining extensible for future enhancements. By focusing initially on the most common operation (adding messages), we can implement a streamlined solution that still lays the groundwork for a more comprehensive messaging system.

This approach pairs well with the timestamp-based pagination method selected for initial message retrieval, creating a comprehensive solution for handling both historical messages and new additions. The repository abstraction properly encapsulates the data operations without exposing implementation details, adhering to clean architecture principles.