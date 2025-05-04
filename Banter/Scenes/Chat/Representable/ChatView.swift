// error nil

import Sharing
import SwiftUI

struct ChatView: UIViewControllerRepresentable {
  @Shared(.userSettings) var settings

  var chatAdress: String

  init(chatAddress: String) {
    self.chatAdress = chatAddress
  }

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context _: Context) -> UIViewController {
    let vc = ChatViewContent()
    
      //Подключить после, на этапе мок эти данные не нужны
      //------
    //let factory = Web3SourceFactory()
    //#warning("Fix this force unwrap")
    //let source = try! factory.makeMessageSource(with: settings, chatAddress: chatAdress)
      //------
    let rep o = MockMessageRepository() //LiveChatMessageRepository(remoteSource: source)
      let senderID = settings.web3.userAddress
      let model = ChatModel(senderId: "user1", chatAddress: chatAdress, view: vc, repo: repo)
    vc.model = model
    return vc
  }

  func updateUIViewController(_: UIViewController, context _: Context) {
    print("update")
  }
}
