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
    lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    override var inputAccessoryView: UIView? { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
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

extension MessageViewController: MessageCellDelegate {
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else { return }
        guard audioController.state != .stopped else {
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }
}
