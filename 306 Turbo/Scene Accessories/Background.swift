//
//  Background.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 09/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    
    init(scene: Level, texture: SKTexture) {
        let cameraScaleX = scene.camera?.xScale ?? 1
        let cameraScaleY = scene.camera?.yScale ?? 1
        var backgroundSize = CGSize(width: scene.size.width * cameraScaleX, height: scene.size.height * cameraScaleY)
        
        if backgroundSize.width > backgroundSize.height {
            backgroundSize = CGSize(width: backgroundSize.width, height: backgroundSize.width)
        } else {
            backgroundSize = CGSize(width: backgroundSize.height, height: backgroundSize.height)
        }
        
        super.init(texture: texture, color: UIColor.clear, size: backgroundSize)
        self.zPosition = -1000
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
