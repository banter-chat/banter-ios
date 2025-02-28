//error nil


import Foundation
import MessageKit

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    static func mockData() -> [Message] {
        [
            Message(sender: Sender(senderId: "selfAdress", displayName: "Self"), messageId: UUID().uuidString, sentDate: Date().addingTimeInterval(-1), kind: .text("Lorem ipsum dolor sit amet, consectetur adipisicing elit")),
            
            Message(sender: Sender(senderId: "2", displayName: "Other"), messageId: UUID().uuidString, sentDate: Date().addingTimeInterval(-3600), kind: .text("Lorem ipsum dolor sit amet, consectetur ")),
            
            Message(sender: Sender(senderId: "selfAdress", displayName: "Self"), messageId: UUID().uuidString, sentDate: Date().addingTimeInterval(-7200), kind: .text("Lorem ipsum dolor t")),
            
            Message(sender: Sender(senderId: "2", displayName: "Other"), messageId: UUID().uuidString, sentDate: Date().addingTimeInterval(-8000), kind: .text("Lorem ipsum dolor sit amet")),
        ]
    }
}