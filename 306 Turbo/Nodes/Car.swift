//
//  Car.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 03/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit

class Car: SKSpriteNode {
    
    private var accelerometer: Accelerometer
    
    private var backWheel: Wheel!
    private var frontWheel: Wheel!
    private var chassis: SKSpriteNode!
    
    var isJumping: Bool
    var haveBoost: Bool
    
    deinit {
        accelerometer.stop()
    }
    
    init(position: CGPoint, scene: SKScene) {
        self.accelerometer = Accelerometer()
        self.isJumping = false
        self.haveBoost = true
        
        super.init(texture: SKTexture(imageNamed: "Car"), color: UIColor.white, size: CGSize(width: 436, height: 134))
        
        self.position = position
        self.zPosition = 100
        self.physicsBody = Physics.bodyFor(car: self)
        self.lightingBitMask = Light.Masks.ambient
        
        scene.addChild(self)
        
        configureChassis(with: scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init
    
    private func configureChassis(with scene: SKScene) {
        backWheel = Wheel(from: self, position: .back)
        frontWheel = Wheel(from: self, position: .front)
        
        scene.addChild(backWheel)
        scene.addChild(frontWheel)
        
        chassis = SKSpriteNode(color: UIColor.red, size: CGSize(width: frontWheel.position.x - backWheel.position.x, height: 10))
        chassis.position = CGPoint(x: position.x, y: position.y - size.height / 2)
        chassis.zPosition = zPosition
        chassis.physicsBody = Physics.bodyFor(chassis: chassis)
        scene.addChild(chassis)
        
        let backWheelJoint = SKPhysicsJointPin.joint(withBodyA: backWheel.physicsBody!, bodyB: chassis.physicsBody!, anchor: backWheel.position)
        let frontWheelJoint = SKPhysicsJointPin.joint(withBodyA: frontWheel!.physicsBody!, bodyB: chassis.physicsBody!, anchor: frontWheel!.position)
        
        scene.physicsWorld.add(backWheelJoint)
        scene.physicsWorld.add(frontWheelJoint)
        
        let damping: CGFloat = 2
        let frenquency: CGFloat = 15
        let backWheelSpring = SKPhysicsJointSpring.joint(withBodyA: chassis.physicsBody!, bodyB: physicsBody!, anchorA: backWheel.position, anchorB: CGPoint(x: backWheel!.position.x, y: backWheel.position.y - backWheel!.size.height / 2))
        let frontWheelSpring = SKPhysicsJointSpring.joint(withBodyA: chassis.physicsBody!, bodyB: physicsBody!, anchorA: frontWheel.position, anchorB: CGPoint(x: frontWheel!.position.x, y: frontWheel.position.y - frontWheel!.size.height / 2))
        
        backWheelSpring.damping = damping
        backWheelSpring.frequency = frenquency
        frontWheelSpring.damping = damping
        frontWheelSpring.frequency = frenquency
        
        scene.physicsWorld.add(backWheelSpring)
        scene.physicsWorld.add(frontWheelSpring)
        
        let backWheelSlide = SKPhysicsJointSliding.joint(withBodyA: chassis.physicsBody!, bodyB: physicsBody!, anchor: backWheel.position, axis: CGVector(dx: 0, dy: 1))
        let frontWheelSlide = SKPhysicsJointSliding.joint(withBodyA: chassis.physicsBody!, bodyB: physicsBody!, anchor: frontWheel.position, axis: CGVector(dx: 0, dy: 1))
        
        scene.physicsWorld.add(backWheelSlide)
        scene.physicsWorld.add(frontWheelSlide)
    }
    
    func remove() {
        for joint in chassis.physicsBody!.joints {
            scene?.physicsWorld.remove(joint)
        }
        
        backWheel.removeFromParent()
        frontWheel.removeFromParent()
        chassis.removeFromParent()
        removeFromParent()
    }
        
    // MARK: - Actions
    
    func moveForward() {
        backWheel.rotate()
        frontWheel.rotate()
    }
    
    func stopMoving() {
        backWheel.stopRotating()
        frontWheel.stopRotating()
    }
    
    func startBreaking() {
        stopMoving()
        frontWheel.physicsBody?.angularDamping = 100
    }
    
    func stopBreaking() {
        backWheel.physicsBody?.angularDamping = 0
        frontWheel.physicsBody?.angularDamping = 0
    }
    
    func jump() {
        guard !isJumping else {
            return
        }
        
        isJumping = true
        accelerometer.start { [weak self] (rotation) in
            self?.physicsBody?.applyTorque(rotation * 50)
        }
    }
    
    func stopJump() {
        isJumping = false
        accelerometer.stop()
    }
    
    func boost() {
        haveBoost = false
        
        let boostAction = SKAction.applyForce(CGVector(dx: 1000, dy: 0), duration: 10)
        run(boostAction)
    }
    
}
