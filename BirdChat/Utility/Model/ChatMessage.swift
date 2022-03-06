//
//  ChatMessage.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 06/03/2022.
//

import Foundation
import MessageKit

struct ChatMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
