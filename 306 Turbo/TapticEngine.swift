//
//  TapticEngine.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 12/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import UIKit

class TapticEngine: NSObject {
    
    static func feedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notify(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

}
