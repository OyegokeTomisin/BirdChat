//
//  ChatViewModel.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 05/03/2022.
//

import Foundation

final class ChatViewModel {
    
    let service = MessengerService()
    
    func startMessagerService() {
        service.connectServer()
    }
    
    func sendMessage(_ message: String?) {
        guard let message = message else { return }
        service.sendMessage(message: message)
    }
}
