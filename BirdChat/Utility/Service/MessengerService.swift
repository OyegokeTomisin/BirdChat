//
//  MessengerService.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 05/03/2022.
//

import Foundation
import SendBirdSDK
import AVFoundation

final class MessengerService: NSObject, MesssengerServiceRepository {
    
    private let USER_ID: String
    private let OTHER_USER: String
    private var channel: SBDBaseChannel?
    
    var shouldUpdateSender: ((Sender) -> Void)?
    var didReceiveMessageUpdate: ((ChatMessage) -> Void)?
    
    init(userID: String, recipientID: String) {
        USER_ID = userID
        OTHER_USER = recipientID
        super.init()
        connectServer()
    }
    
    func sendMessage(message: String, completion: @escaping () -> Void) {
        channel?.sendUserMessage(message) { userMessage, error in
            completion()
            guard let userMessage = userMessage, error == nil else { return }
            self.updateMessageUIForSender(with: userMessage)
        }
    }
    
    func sendVoiceNote(from file: Data, with fileName: String, completion: @escaping () -> Void) {
        guard let params = SBDFileMessageParams.init(file: file) else { return }
        params.fileName = fileName
        params.mimeType = "audio/m4a"
        // params.fileSize = FILE_SIZE
        channel?.sendFileMessage(with: params, completionHandler: { (fileMessage, error) in
            completion()
            guard error == nil else { return }
            guard let recipient = fileMessage?.sender?.asSender, let message = fileMessage else { return }
            self.updateMessageUIForRecipient(with: message, recipient: recipient)
        })
    }
    
    private func connectServer() {
        SBDMain.add(self, identifier: "CLASS_IDENTIFIER")
        SBDMain.connect(withUserId: USER_ID) { [weak self] user, error in
            guard let user = user, error == nil else { return }
            self?.createChannel(for: user)
        }
    }
    
    private func createChannel(for user: SBDUser) {
        SBDGroupChannel.createChannel(withUserIds: [OTHER_USER], isDistinct: true) { [weak self] channel, error in
            guard let messengerChannel = channel, error == nil else { return }
            self?.channel = messengerChannel
            self?.shouldUpdateSender?(user.asSender)
        }
    }
    
    private func updateMessageUIForSender(with message: SBDUserMessage) {
        guard let name = message.sender?.nickname else { return  }
        let sender = Sender(senderId: USER_ID, displayName: name)
        let chatMessage = ChatMessage(sender: sender, messageId: String("\(message.messageId)"), sentDate: Date(), kind: .text(message.message))
        didReceiveMessageUpdate?(chatMessage)
    }
    
    private func updateMessageUIForRecipient(with message: SBDBaseMessage, recipient: Sender) {
        if message is SBDFileMessage {
            if let fileMessage = message as? SBDFileMessage, let fileURL = URL(string: fileMessage.url) {
                FileDownloader.downloadFile(audioUrl: fileURL) { locationURL in
                    let audioItem = AudioMessage(url: locationURL,
                                                 duration: Float(CMTimeGetSeconds(AVURLAsset(url: locationURL).duration)),
                                                 size: CGSize(width: 160, height: 35))
                    let audioMessage = ChatMessage(sender: recipient, messageId: String("\(message.messageId)"), sentDate: Date(), kind: .audio(audioItem))
                    self.didReceiveMessageUpdate?(audioMessage)
                }
            }
        }
        
        if message is SBDUserMessage {
            let chatMessage = ChatMessage(sender: recipient, messageId: String("\(message.messageId)"), sentDate: Date(), kind: .text(message.message))
            didReceiveMessageUpdate?(chatMessage)
        }
    }
}

extension MessengerService: SBDChannelDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        guard let recipient = message.sender?.asSender else { return }
        updateMessageUIForRecipient(with: message, recipient: recipient)
    }
}

extension SBDUser {
    var asSender: Sender {
        return Sender(senderId: self.userId, displayName: self.nickname ?? "")
    }
}
