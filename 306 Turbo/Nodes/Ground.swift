//
//  Ground.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 03/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: UIColor.lightGray, size: CGSize(width: 999999, height: 1000))
        
        self.position = CGPoint(x: size.width / 2 - UIScreen.main.bounds.width, y: -size.height / 2)
        self.physicsBody = Physics.bodyFor(ground: self)
        self.lightingBitMask = Light.Masks.ambient
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
