//
//  EndUI.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 12/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class EndUI: SKNode {
    
    private var distance: Int
    private var height: Int
    private var isBestDistance: Bool
    private var isBestHeight: Bool
    
    var distanceLabel: SKLabelNode!
    var heightLabel: SKLabelNode!
    
    init(distance: Int, height: Int) {
        self.distance = distance
        self.height = height
        self.isBestDistance = distance > Configuration.shared.currentConfiguration?.bestDistance ?? 0
        self.isBestHeight = height > Configuration.shared.currentConfiguration?.bestHeight ?? 0
        
        super.init()
        
        configureLabels()
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabels() {
        distanceLabel = SKLabelNode(text: "0m")
        distanceLabel.position = CGPoint(x: 0, y: distanceLabel.frame.size.height)
        
        heightLabel = SKLabelNode(text: "0m")
        heightLabel.position = CGPoint(x: 0, y: -heightLabel.frame.size.height)
        
        addChild(distanceLabel)
        addChild(heightLabel)
    }
    
    // MARK: - Animation
    
    private func animate() {
        let incrementDistance = incrementAction(with: distance, label: distanceLabel)
        let scaleDistance = scaleAnimationFor(label: distanceLabel)
        let incrementHeight = incrementAction(with: height, label: heightLabel)
        let scaleHeight = scaleAnimationFor(label: heightLabel)
        let wait = SKAction.wait(forDuration: 1)
        let sequence = SKAction.sequence([incrementDistance, scaleDistance, wait, incrementHeight, scaleHeight])
        
        run(sequence)
    }
    
    private func incrementAction(with value: Int, label: SKLabelNode) -> SKAction {
        let increment = SKAction.customAction(withDuration: 1) { (node, duration) in
            label.text = "\(Int(duration * CGFloat(value)))m"
        }
        
        return increment
    }
    
    private func scaleAnimationFor(label: SKLabelNode) -> SKAction {
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let notify = SKAction.customAction(withDuration: 0) { (_, _) in
            TapticEngine.notify(type: .success)
        }
        let scaleDown = SKAction.scale(to: 1, duration: 0.4)
        let sequence = SKAction.sequence([scaleUp, notify, scaleDown])
        
        return SKAction.customAction(withDuration: 0, actionBlock: { (_, _) in
            label.run(sequence)
        })
    }
    
}

extension EndUI: UIProtocol {
    
    var node: SKNode {
        return self
    }
    
    func update(from scene: Level) {
        
    }
    
    func remove() {
        removeFromParent()
    }
    
}
