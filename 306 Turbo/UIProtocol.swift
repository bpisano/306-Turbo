//
//  UIProtocol.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 11/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

protocol UIProtocol {
    
    var node: SKNode { get }
    
    func update(from scene: Level)
    func remove()
    
}
