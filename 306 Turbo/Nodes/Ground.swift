//
//  Ground.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 03/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    
    init(from scene: Level) {
        super.init(texture: SKTexture(imageNamed: "Campagne_ground"), color: UIColor.green, size: CGSize(width: 999999, height: 600))
        
        self.position = CGPoint(x: size.width / 2 - scene.size.width / 2 - 300, y: -size.height / 2)
        self.zPosition = -10
        self.physicsBody = Physics.bodyFor(ground: self)
        self.lightingBitMask = Light.Masks.ambient
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
