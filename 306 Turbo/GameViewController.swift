//
//  GameViewController.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 03/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Configuration.loadConfiguration()
        loadLevel()
    }
    
    private func loadLevel() {
        guard let view = view as? SKView else {
            return
        }
        
        if let scene = SKScene(fileNamed: "Level") {
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }

}
