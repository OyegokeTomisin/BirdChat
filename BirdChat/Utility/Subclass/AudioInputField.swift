//
//  AudioInputField.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 05/03/2022.
//

import UIKit

final class AudioInputField: BaseView {
    
    let recordingSendButton = UIButton()
    let recordingStopButton = UIButton()
    let recordingCancelButton = UIButton()
    
    let recordingContainer = UIView()
    let waveformContainer = UIView()
    let controlsContainer = UIView()
    let recordingLabel = UILabel()
    
    let progressBar = UIProgressView()
    
    private let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
    
    override func setup() {
        super.setup()
        
        recordingLabel.text = "00:00"
        recordingLabel.textColor = .white
        
        recordingSendButton.layer.cornerRadius = 20
        recordingSendButton.tintColor = UIColor.white
        recordingSendButton.constrainHeight(constant: 40)
        recordingSendButton.constrainWidth(constant: 40)
        recordingSendButton.setImage(UIImage(systemName: "arrow.up.message.fill", withConfiguration: largeConfig), for: .normal)
        
        recordingCancelButton.layer.cornerRadius = 15
        recordingCancelButton.tintColor = UIColor.white
        recordingCancelButton.constrainHeight(constant: 30)
        recordingCancelButton.constrainWidth(constant: 30)
        recordingCancelButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: largeConfig), for: .normal)
        
        recordingStopButton.layer.cornerRadius = 20
        recordingStopButton.backgroundColor = .red
        recordingStopButton.tintColor = UIColor.white
        recordingStopButton.constrainHeight(constant: 40)
        recordingStopButton.constrainWidth(constant: 40)
        recordingStopButton.setImage(UIImage(systemName: "record.circle", withConfiguration: largeConfig), for: .normal)
        
        let waveStack = HorizontalStack(arrangedSubviews: [recordingCancelButton, progressBar, recordingLabel], spacing: 10, alignment: .center)
        waveformContainer.addSubview(waveStack)
        waveStack.fillSuperview(padding: .init(top: 0, left: 10, bottom: 0, right: 10))
        
        waveformContainer.backgroundColor = .lightGray
        waveformContainer.constrainHeight(constant: 40)
        waveformContainer.layer.cornerRadius = 20
        
        controlsContainer.backgroundColor  = .lightGray
        controlsContainer.constrainHeight(constant: 150)
        controlsContainer.constrainWidth(constant: 60)
        controlsContainer.layer.cornerRadius = 30
        
        let recordingButtonStack = VerticalStack(arrangedSubviews: [recordingSendButton, recordingStopButton], distribution: .equalSpacing, alignment: .bottom)
        controlsContainer.addSubviews(recordingButtonStack)
        recordingButtonStack.centerXInSuperview()
        recordingButtonStack.anchor(top: controlsContainer.topAnchor, leading: nil, bottom: controlsContainer.bottomAnchor, trailing: nil, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
        
        let recordingStack = HorizontalStack(arrangedSubviews: [waveformContainer, controlsContainer], spacing: 5, alignment: .bottom)
        
        addSubview(recordingContainer)
        
        recordingContainer.addSubviews(recordingStack)
        recordingStack.anchor(top: recordingContainer.topAnchor, leading: recordingContainer.leadingAnchor, bottom: recordingContainer.bottomAnchor, trailing: recordingContainer.trailingAnchor)
        recordingContainer.fillSuperview()
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

struct AudioInputViewLayoutPreview: PreviewProvider {
    static var previews: some View {
        BasePreviewProvider<AudioInputField>()
    }
}

#endif
