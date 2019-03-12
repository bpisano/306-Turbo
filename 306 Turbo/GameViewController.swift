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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadLevel()
    }
    
    private func loadLevel() {
        guard let view = view as? SKView else {
            return
        }
        
        if let scene = SKScene(fileNamed: "Campagne") {
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
        }
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
