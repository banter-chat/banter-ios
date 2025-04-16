//error nil

import UIKit
import MessageKit
import InputBarAccessoryView

protocol ChatViewContentProtocol: AnyObject{
    func updateChat()
}

class ChatViewContent: MessagesViewController, ChatViewContentProtocol {
    
    var model: ChatModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMessageTimestampOnSwipeLeft = true
        messagerSetup()
        messagesCollectionView.reloadDataAndKeepOffset()
        setupInputBar()
        model.viewAppeared()
    }
    
    private func messagerSetup(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
    }
    
    private func setupInputBar(){
        messageInputBar.inputTextView.placeholder = "Cообщение"
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.inputTextView.layer.cornerRadius = 10
        //messageInputBar.inputTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    private func insertMessage(message: Message){
        messagesCollectionView.reloadData()
       model.sendMessageTapped(message: message)
    }
    
    func updateChat() {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
        }
        
    }
}



extension ChatViewContent: MessagesDataSource{
    var currentSender: any MessageKit.SenderType {
        model.selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        model.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        model.messages.count
    }
    
}


extension ChatViewContent:InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message: Message = Message(sender: model.selfSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
        
        self.insertMessage(message: message)
        inputBar.inputTextView.text = ""
        
    }
   
}

extension ChatViewContent:MessagesDisplayDelegate, MessagesLayoutDelegate{
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor{
        message.sender.senderId == model.selfSender.senderId ? .black : .gray
    }

    func messageTopLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func messageBottomLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sentDate.formatted()
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func avatarSize(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        .zero
    }
    
}
