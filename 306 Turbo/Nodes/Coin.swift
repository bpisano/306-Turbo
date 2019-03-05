//
//  Coin.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 05/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode {
    
    init(position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: "Coin"), color: UIColor.clear, size: CGSize(width: 70, height: 70))
        
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
