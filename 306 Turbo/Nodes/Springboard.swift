//
//  Springboard.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 04/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class Springboard: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "Springboard")
        let size = texture.size()
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: size.width * 3, height: size.height * 3))
        
        self.physicsBody = Physics.bodyFor(springboard: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
