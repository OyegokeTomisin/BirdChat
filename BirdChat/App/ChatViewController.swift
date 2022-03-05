//
//  ChatViewController.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 04/03/2022.
//

import UIKit

final class ChatViewController: UIViewController {
    
    let messageInputField = MessageInputField()
    let audioInputField = AudioInputField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubviews(messageInputField)
        messageInputField.constrainHeight(constant: 40)
        messageInputField.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        
        view.backgroundColor = .white
        view.addSubviews(audioInputField)
        audioInputField.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        messageInputField.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        messageInputField.recordButton.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
        audioInputField.recordingSendButton.addTarget(self, action: #selector(sendRecording), for: .touchUpInside)
        audioInputField.recordingStopButton.addTarget(self, action: #selector(stopRecording), for: .touchUpInside)
        audioInputField.recordingCancelButton.addTarget(self, action: #selector(cancelRecording), for: .touchUpInside)
        
        cancelRecording()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func startRecording() {
        messageInputField.isHidden = true
        audioInputField.isHidden = false
    }
    
    @objc func cancelRecording() {
        messageInputField.isHidden = false
        audioInputField.isHidden = true
    }
    
    @objc func stopRecording() {
        
    }
    
    @objc func sendRecording() {
        cancelRecording()
    }
    
    @objc func sendMessage() {
        messageInputField.sendMessage()
        // debugPrint(messageInputField.texView.text)
    }
    
    @objc func dismissKeyboard() {
        stopRecording()
        messageInputField.texView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardFrame = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y = -keyboardFrame.size.height
            })
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
