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
    
    private var backWheel: Wheel?
    private var frontWheel: Wheel?
    
    var isJumping: Bool
    
    init(position: CGPoint, scene: SKScene) {
        self.accelerometer = Accelerometer()
        self.isJumping = false
        
        super.init(texture: SKTexture(imageNamed: "Car"), color: UIColor.white, size: CGSize(width: 436, height: 134))
        
        self.position = position
        self.physicsBody = Physics.bodyFor(car: self)
        
        scene.addChild(self)
        
        configureChassis(with: scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureWheels(with scene: SKScene) {
        backWheel = Wheel(from: self, position: .back)
        frontWheel = Wheel(from: self, position: .front)
        
        scene.addChild(backWheel!)
        scene.addChild(frontWheel!)
    }
    
    private func configureChassis(with scene: SKScene) {
        backWheel = Wheel(from: self, position: .back)
        frontWheel = Wheel(from: self, position: .front)
        
        scene.addChild(backWheel!)
        scene.addChild(frontWheel!)
        
        let chassis = SKSpriteNode(color: UIColor.red, size: CGSize(width: (frontWheel?.position.x ?? 0) - (backWheel?.position.x ?? 0), height: 10))
        chassis.position = CGPoint(x: position.x, y: position.y - size.height / 2)
        chassis.physicsBody = Physics.bodyFor(chassis: chassis)
        scene.addChild(chassis)
        
        let backWheelJoint = SKPhysicsJointPin.joint(withBodyA: backWheel!.physicsBody!, bodyB: chassis.physicsBody!, anchor: backWheel!.position)
        let frontWheelJoint = SKPhysicsJointPin.joint(withBodyA: frontWheel!.physicsBody!, bodyB: chassis.physicsBody!, anchor: frontWheel!.position)
        
        scene.physicsWorld.add(backWheelJoint)
        scene.physicsWorld.add(frontWheelJoint)
        
        let damping: CGFloat = 2
        let frenquency: CGFloat = 15
        let backWheelSpring = SKPhysicsJointSpring.joint(withBodyA: chassis.physicsBody!, bodyB: physicsBody!, anchorA: backWheel!.position, anchorB: CGPoint(x: backWheel!.position.x, y: backWheel!.position.y - backWheel!.size.height / 2))
        let frontWheelSpring = SKPhysicsJointSpring.joint(withBodyA: chassis.physicsBody!, bodyB: physicsBody!, anchorA: frontWheel!.position, anchorB: CGPoint(x: frontWheel!.position.x, y: frontWheel!.position.y - frontWheel!.size.height / 2))
        
        backWheelSpring.damping = damping
        backWheelSpring.frequency = frenquency
        frontWheelSpring.damping = damping
        frontWheelSpring.frequency = frenquency
        
        scene.physicsWorld.add(backWheelSpring)
        scene.physicsWorld.add(frontWheelSpring)
        
        let backWheelSlide = SKPhysicsJointSliding.joint(withBodyA: chassis.physicsBody!, bodyB: physicsBody!, anchor: backWheel!.position, axis: CGVector(dx: 0, dy: 1))
        let frontWheelSlide = SKPhysicsJointSliding.joint(withBodyA: chassis.physicsBody!, bodyB: physicsBody!, anchor: frontWheel!.position, axis: CGVector(dx: 0, dy: 1))
        
        scene.physicsWorld.add(backWheelSlide)
        scene.physicsWorld.add(frontWheelSlide)
    }
    
    func moveForward() {
        backWheel?.rotate()
        frontWheel?.rotate()
    }
    
    func stopMoving() {
        backWheel?.stopRotating()
        frontWheel?.stopRotating()
    }
    
    func startBreaking() {
        frontWheel?.physicsBody?.angularDamping = 100
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
    
}
