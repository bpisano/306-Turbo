//
//  Wheel.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 03/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class Wheel: SKSpriteNode {
    
    enum Position {
        
        case back
        case front
        
    }
    
    private var wheelSize: CGSize = CGSize(width: 70, height: 70)
    
    init(from car: Car, position: Wheel.Position) {
        super.init(texture: SKTexture(imageNamed: "Wheel"), color: UIColor.black, size: wheelSize)
        
        if position == .back {
            self.position = CGPoint(x: car.position.x - car.size.width / 2 + wheelSize.width / 2 + 22, y: car.position.y - car.size.height / 2)
        } else {
            self.position = CGPoint(x: car.position.x - car.size.width / 2 + wheelSize.width / 2 + 333, y: car.position.y - car.size.height / 2)
        }
        self.zPosition = car.zPosition
        self.physicsBody = Physics.bodyFor(wheel: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate() {
        let actionDuration: TimeInterval = 5
        let rotate = SKAction.customAction(withDuration: actionDuration) { (node, duration) in
            self.physicsBody?.applyTorque(-duration)
        }
        let continueRotation = SKAction.customAction(withDuration: 999999) { (node, duration) in
            self.physicsBody?.applyTorque(CGFloat(-actionDuration))
        }
        let sequence = SKAction.sequence([rotate, continueRotation])
        
        run(sequence)
    }
    
    func stopRotating() {
        removeAllActions()
    }
    
}
