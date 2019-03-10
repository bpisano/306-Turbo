//
//  Campagne.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 07/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class Campagne: Level {
        
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureScene()
    }
    
    private func configureScene() {
        guard let currentConfiguration = Configuration.shared.currentConfiguration else {
            return
        }
        
        switch currentConfiguration.time {
        case .morning:
            backgroundTexture = SKTexture(imageNamed: "Campagne_background_morning")
            ambientLightColor = UIColor.white
        case .afternoon:
            backgroundTexture = SKTexture(imageNamed: "Campagne_background_afternoon")
            lightColor = UIColor(white: 0.1, alpha: 1)
            ambientLightColor = UIColor(red: 105/255, green: 45/255, blue: 63/255, alpha: 1)
        case .night:
            backgroundTexture = SKTexture(imageNamed: "Campagne_background_night")
            lightColor = UIColor.white.withAlphaComponent(0.5)
            ambientLightColor = UIColor.black
        }
    }
    
}
