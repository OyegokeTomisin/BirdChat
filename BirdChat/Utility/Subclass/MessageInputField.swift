//
//  MessageInputField.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 04/03/2022.
//

import UIKit

final class MessageInputField: BaseView {
    
    let texView = UITextView()
    let actionContainer = UIView()
    let viewContainer = UIView()
    
    let sendButton = UIButton()
    let recordButton = UIButton()
    
    override func setup() {
        super.setup()
        
        texView.text = "Holà"
        texView.delegate = self
        texView.textColor = UIColor.lightGray
        
        recordButton.layer.cornerRadius = 15
        recordButton.backgroundColor = .gray
        recordButton.tintColor = UIColor.white
        recordButton.setImage(UIImage(systemName: "waveform"), for: .normal)
        
        sendButton.layer.cornerRadius = 15
        sendButton.backgroundColor = .blue
        sendButton.tintColor = UIColor.white
        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.cornerRadius = 15
        viewContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        actionContainer.layer.cornerRadius = 15
        actionContainer.backgroundColor  = .yellow
        actionContainer.constrainHeight(constant: 30)
        actionContainer.constrainWidth(constant: 30)
        
        addSubview(viewContainer)
        
        viewContainer.addSubviews(texView, actionContainer)
        viewContainer.fillSuperview()
        
        texView.anchor(top: viewContainer.topAnchor, leading: viewContainer.leadingAnchor, bottom: viewContainer.bottomAnchor, trailing: actionContainer.leadingAnchor, padding: .init(top: 5, left: 5, bottom: 0, right: 5))
        
        actionContainer.anchor(top: nil, leading: nil, bottom: viewContainer.bottomAnchor, trailing: viewContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 5))
        
        actionContainer.addSubviews(sendButton, recordButton)
        
        recordButton.fillSuperview()
        sendButton.fillSuperview()
    }
    
    func toggleRecordButton() {
        recordButton.isHidden = texView.text.count > 0
        sendButton.isHidden = !recordButton.isHidden
    }
    
    func clearTextInput() {
        texView.text = nil
    }
    
    func setPlaceHolderState() {
        if texView.text.isEmpty {
            texView.text = "Holà"
            texView.textColor = UIColor.lightGray
        } else {
            texView.text = nil
            texView.textColor = UIColor.black
        }
    }
}

extension MessageInputField: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        toggleRecordButton()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        texView.text = nil
        texView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if texView.text.isEmpty {
            texView.text = "Holà"
            texView.textColor = UIColor.lightGray
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

struct MessageInputFieldLayoutPreview: PreviewProvider {
    static var previews: some View {
        BasePreviewProvider<MessageInputField>()
    }
}

#endif
