//error nil

import SwiftUI

struct ChatView: UIViewControllerRepresentable{
    var model: ChatModel
    
    init(chatAddress: String) {
        self.model = ChatModel(chatAddress: chatAddress)
    }
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return ChatViewContent(model: model)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
   
}
