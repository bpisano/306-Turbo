//
//  StartUI.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 11/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class StartUI: SKNode {
    
    private let topInset: CGFloat = 16
    
    init(scene: SKScene) {
        super.init()
        
        addTitle(with: scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTitle(with scene: SKScene) {
        let title = SKSpriteNode(texture: SKTexture(imageNamed: "Title"), color: UIColor.clear, size: CGSize(width: 250, height: 155))
        title.position = CGPoint(x: 0, y: scene.size.height / 2 - title.size.height / 2 - (scene.view?.safeAreaInsets.top ?? 0) - topInset)
        
        addChild(title)
    }
    
}

extension StartUI: UIProtocol {
    
    var node: SKNode {
        return self
    }
    
    func update(from scene: Level) {
        
    }
    
    func remove() {
        removeFromParent()
    }
    
}
