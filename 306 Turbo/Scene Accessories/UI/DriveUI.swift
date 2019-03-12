//
//  DriveUI.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 11/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class DriveUI: SKNode {
    
    private let topInset: CGFloat = 16
    
    var longDistanceLabel: SKLabelNode!
    
    init(scene: SKScene) {
        super.init()
        
        addLongDistanceLabel(with: scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLongDistanceLabel(with scene: SKScene) {
        longDistanceLabel = SKLabelNode(text: "0m")
        longDistanceLabel.position = CGPoint(x: 0, y: scene.size.height / 2 - longDistanceLabel.frame.size.height - (scene.view?.safeAreaInsets.top ?? 0) - topInset)
        
        addChild(longDistanceLabel)
    }
    
}

extension DriveUI: UIProtocol {
    
    var node: SKNode {
        return self
    }
    
    func update(from scene: Level) {
        guard let car = scene.car, car.isJumping else {
            return
        }
        
        let meterDistance = Maths.meterPositionFrom(position: car.position, springBoardPosition: scene.springboard.position).x
        longDistanceLabel.text = "\(Int(meterDistance))m"
    }
    
    func remove() {
        removeFromParent()
    }
    
}
