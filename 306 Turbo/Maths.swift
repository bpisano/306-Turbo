//
//  Maths.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 12/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import UIKit

class Maths: NSObject {
    
    static private var meterFactor: CGFloat = 109
    
    static func meterPositionFrom(position: CGPoint, springBoardPosition: CGPoint) -> CGPoint {
        return CGPoint(x: (position.x - springBoardPosition.x) / meterFactor, y: (position.y - springBoardPosition.y) / meterFactor)
    }

}
