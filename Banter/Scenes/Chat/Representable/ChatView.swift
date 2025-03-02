//error nil

import SwiftUI

struct ChatView: UIViewControllerRepresentable{
    var chatAdress: String
    
    init(chatAddress: String) {
        self.chatAdress = chatAddress
    }
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = ChatViewContent()
        let model = ChatModel(chatAddress: chatAdress, view: vc)
        vc.model = model
        return vc
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        print("update")
    }
}
