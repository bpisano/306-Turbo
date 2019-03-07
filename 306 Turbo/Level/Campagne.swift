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
        
        backgroundTexture = SKTexture(imageNamed: "Campagne_background_afternoon")
        lightColor = UIColor.white
        ambientLightColor = UIColor(red: 245/255, green: 98/255, blue: 23/255, alpha: 1)
    }
    
}
