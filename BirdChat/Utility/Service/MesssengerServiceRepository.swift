//
//  MesssengerServiceRepository.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 06/03/2022.
//

import Foundation

protocol MesssengerServiceRepository {
    var shouldUpdateSender: ((Sender) -> Void)? { get set }
    var didReceiveMessageUpdate: ((ChatMessage) -> Void)? { get set }
    func sendMessage(message: String, completion: @escaping () -> Void)
    func sendVoiceNote(from file: Data, with fileName: String, completion: @escaping () -> Void)
}
