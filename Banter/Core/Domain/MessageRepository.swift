// MessageRepository.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 26/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

protocol MessageRepository {
    ///В качестве ``id`` поставил String
    ///Более гибко получается без привязки к конкретным объектам
    ///На выходе сделал ``Message`` но я думаю что тут надо будет сделать
    ///протоколом, что бы не было привязки к конкретным объектам
    func getMessages(id: /*Chat.ID*/ String) async throws -> [Message]
  // messagesStream(id: Chat.ID) async throws -> AsyncSequence<[ChatMessage]>
}
