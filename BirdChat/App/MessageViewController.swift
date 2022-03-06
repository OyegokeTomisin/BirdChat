//
//  MessageViewController.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 05/03/2022.
//

import UIKit
import MessageKit

final class MessageViewController: MessagesViewController, MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    var currentUser: Sender?
    var messages: [ChatMessage] = []
    
    override var inputAccessoryView: UIView? { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func currentSender() -> SenderType {
        currentUser ?? Sender(senderId: "", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
