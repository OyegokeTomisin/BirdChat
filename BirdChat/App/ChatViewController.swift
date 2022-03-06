//
//  ChatViewController.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 04/03/2022.
//

import UIKit
import AVFoundation

final class ChatViewController: UIViewController {
    
    let viewModel = ChatViewModel()
    
    private let messageInputField = MessageInputField()
    private let audioInputField = AudioInputField()
    private let messageListContainer = UIView()
    private let messageViewController = MessageViewController()
    
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMessageListContainer()
        
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
        
        loadAudioSession()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        viewModel.service.didReceiveMessageUpdate = { meesage in
            self.messageViewController.messages.append(meesage)
            self.messageViewController.messagesCollectionView.reloadData()
        }
        viewModel.service.shouldUpdateSender = { sender in
            self.messageViewController.currentUser = sender
        }
    }
    
    @objc func startRecording() {
        DispatchQueue.main.async {
            self.messageInputField.isHidden = true
            self.audioInputField.isHidden = false
        }
        startAudioRecording()
    }
    
    @objc func cancelRecording() {
        messageInputField.isHidden = false
        audioInputField.isHidden = true
    }
    
    @objc func stopRecording() {
        finishRecording(success: true)
    }
    
    @objc func sendRecording() {
        cancelRecording()
        let fileName = "recording.m4a"
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        if let audioData = try? Data(contentsOf: audioFilename) {
            viewModel.service.sendVoiceNote(from: audioData, with: fileName, completion: { })
        }
    }
    
    @objc func sendMessage() {
        viewModel.sendMessage(messageInputField.texView.text) { [weak self] in
            self?.messageInputField.clearTextInput()
        }
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
    
    private func setupMessageListContainer() {
        view.addSubviews(messageListContainer)
        messageListContainer.fillSuperview()
        addChild(messageViewController)
        messageListContainer.addSubview(messageViewController.view)
        messageViewController.view.fillSuperview()
        messageViewController.didMove(toParent: self)
    }
}

extension ChatViewController {
    
    func loadAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
            recordingSession?.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    self.messageInputField.recordButton.isHidden = !allowed
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func startAudioRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
}

extension ChatViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
