//error nil


import MessageKit


/// В качестве ``senderId`` будет использоваться адрес кошелка
/// ``displayName`` в начальной версии будет пустым
/// потом надо будет продумать логику получения пользовательских даннх
/// между собеседниками

struct Sender: SenderType{
    var senderId: String
    var displayName: String
}
