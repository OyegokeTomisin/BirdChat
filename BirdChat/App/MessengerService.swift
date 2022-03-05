//
//  MessengerService.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 05/03/2022.
//

import Foundation
import SendBirdSDK

final class MessengerService: NSObject {
    
    let USER_ID = "user123"
    let CHANNEL_NAME = "buddies"
    let CHANNEL_URL = "sendbird_open_channel_97362_871111b200a0586fe3b3f72f736d14dd8a9098a4"
    
    let CLASS_IDENTIFIER = ""
    
    var channel: SBDBaseChannel?
    var user: SBDUser?
    
    override init() {
        super.init()
        SBDMain.add(self, identifier: CLASS_IDENTIFIER)
    }
    
    func connectServer() {
        SBDMain.connect(withUserId: USER_ID) { user, error in
            guard let user = user, error == nil else {
                return // Handle error.
            }
            self.user = user
            self.enterChannel()
        }
    }
    
    func createChannel() {
        let params = SBDOpenChannelParams()
        params.name = CHANNEL_NAME
        
        SBDOpenChannel.createChannel(with: params) { channel, error in
            guard let channel = channel, error == nil else {
                return // Handle error.
            }
            
            self.channel = channel
            
            // An open channel is successfully created.
            // Through the "openChannel" parameter of the callback method,
            // you can get the open channel's data from the Sendbird server.
        }
    }
    
    func enterChannel() {
        SBDOpenChannel.getWithUrl(CHANNEL_URL) { openChannel, error in
            guard let openChannel = openChannel, error == nil else {
                return // Handle error.
            }
            // Call the instance method of the result object in the "openChannel" parameter of the callback method.
            self.channel = openChannel
            
            openChannel.enter(completionHandler: { error in
                guard error == nil else {
                    return
                }
                // The current user successfully enters the open channel,
                // and can chat with other users in the channel by using APIs.
            })
        }
    }
    
    func sendMessage(message: String) {
        channel?.sendUserMessage(message) { userMessage, error in
            
            guard let userMessage = userMessage, error == nil else {
                return // Handle error.
            }
            
            // The message is successfully sent to the channel.
            // The current user can receive messages from other users through the channel:didReceiveMessage: method of an event delegate.
        }
    }
}

extension MessengerService: SBDChannelDelegate {
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        debugPrint(message)
    }
}
