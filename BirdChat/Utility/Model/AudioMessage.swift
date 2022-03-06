//
//  AudioMessage.swift
//  BirdChat
//
//  Created by Oyegoke Oluwatomisin on 06/03/2022.
//

import Foundation
import MessageKit

struct AudioMessage: AudioItem {
    var url: URL
    var duration: Float
    var size: CGSize
}
