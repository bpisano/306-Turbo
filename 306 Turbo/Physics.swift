//
//  Physics.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 03/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import UIKit

import SpriteKit

class Physics: NSObject {
    
    struct Masks {
        
        static let car: UInt32 = 0x01 << 0
        static let wheel: UInt32 = 0x01 << 1
        static let chassis: UInt32 = 0x01 << 2
        static let ground: UInt32 = 0x01 << 3
        static let springboard: UInt32 = 0x01 << 4
        
    }
    
    static func bodyFor(car: SKSpriteNode) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(texture: car.texture!, size: car.size)
        
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = true
        physicsBody.restitution = 0.3
        physicsBody.friction = 0.5
        physicsBody.categoryBitMask = Masks.car
        physicsBody.collisionBitMask = Masks.ground | Masks.springboard
        
        return physicsBody
    }
    
    static func bodyFor(chassis: SKSpriteNode) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: chassis.size)
        
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = true
        physicsBody.categoryBitMask = Masks.chassis
        
        return physicsBody
    }
    
    static func bodyFor(wheel: SKSpriteNode) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(circleOfRadius: wheel.size.width / 2)
        
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = true
//        physicBody.mass = 0.1
        physicsBody.restitution = 0
        physicsBody.friction = 1
        physicsBody.linearDamping = 0
        physicsBody.categoryBitMask = Masks.wheel
        physicsBody.collisionBitMask = Masks.ground | Masks.springboard
        physicsBody.contactTestBitMask = Masks.ground
        
        return physicsBody
    }
    
    static func bodyFor(ground: SKSpriteNode) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground.size.width, height: ground.size.height - 140))
        
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.restitution = 0
        physicsBody.friction = 1
//        physicsBody.linearDamping = 30
//        physicsBody.angularDamping = 30
        physicsBody.categoryBitMask = Masks.ground
        physicsBody.collisionBitMask = Masks.car | Masks.wheel | Masks.springboard
        
        return physicsBody
    }
    
    static func bodyFor(springboard: SKSpriteNode) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(texture: springboard.texture!, size: springboard.size)
        
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = false
        physicsBody.mass = 100
        physicsBody.restitution = 0
        physicsBody.friction = 1
//        physicsBody.linearDamping = 30
//        physicsBody.angularDamping = 30
        physicsBody.categoryBitMask = Masks.springboard
        physicsBody.collisionBitMask = Masks.car | Masks.wheel | Masks.ground
        
        return physicsBody
    }
    
}

