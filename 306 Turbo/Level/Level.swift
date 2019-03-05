//
//  Level.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 03/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit
import GameplayKit

enum LevelState {
    
    case start
    case driving
    case end
    
}

class Level: SKScene {
    
    private var state: LevelState = .start
    
    var car: Car?
    var ground: Ground!
    var springboard: Springboard!
        
    override func didMove(to view: SKView) {
        configureGround()
        configureSpringboard()
        configureCamera()
        configureContact()
        
        setStartState()
    }
    
    // MARK: - Init
    
    private func configureGround() {
        ground = Ground()
        addChild(ground)
    }
    
    private func configureCar() {
        car = Car(position: CGPoint(x: 50, y: 300), scene: self)
    }
    
    private func configureSpringboard() {
        springboard = Springboard()
        springboard.position = CGPoint(x: 5000, y: ground.position.y + ground.size.height / 2 + springboard.size.height / 2)
        
        addChild(springboard)
    }
    
    private func configureCamera() {
        let camera = SKCameraNode()
        camera.setScale(1.5)

        self.camera = camera
        addChild(camera)
    }
    
    private func configureContact() {
        physicsWorld.contactDelegate = self
    }
    
    // MARK: - Game Engine
    
    override func update(_ currentTime: TimeInterval) {
        updateCameraPosition()
        
        if let car = car, car.position.x > 5000 && car.position.x < 5100 {
            car.jump()
        }
    }
    
    // MARK: - Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let car = car else {
            return
        }
        
        switch state {
        case .start:
            setDrivingState()
        case .driving:
            car.moveForward()
        case .end:
            setStartState()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let car = car else {
            return
        }
        
        if state == .driving {
            car.stopMoving()
        }
    }
    
    // MARK: - Camera
    
    private func defaultCameraPosition() -> CGPoint {
        guard let car = car else {
            return CGPoint.zero
        }
        
        return CGPoint(x: car.position.x + size.width / 2 - car.size.width / 2 - 20, y: car.position.y + size.height / 2 - car.size.height - 100)
    }
    
    private func carCameraPosition() -> CGPoint {
        guard let car = car else {
            return CGPoint.zero
        }
        
        return car.position
    }
    
    private func updateCameraPosition() {
        camera?.position = defaultCameraPosition()
    }
    
    // MARK: - States
    
    func setStartState() {
        car?.remove()
        car = Car(position: CGPoint(x: 0, y: 200), scene: self)
        
        camera?.childNode(withName: "label")?.removeFromParent()
        let label = SKLabelNode(text: "Start")
        label.name = "label"
        camera?.addChild(label)
        
        state = .start
    }
    
    func setDrivingState() {
        camera?.childNode(withName: "label")?.removeFromParent()
        
        state = .driving
    }
    
    func setEndState() {
        let label = SKLabelNode(text: "End")
        label.name = "label"
        camera?.addChild(label)
        state = .end
    }
    
    // MARK: - Animation
    
    private func endAnimation() {
        let slowMotion = SKAction.customAction(withDuration: 0.2) { (node, duration) in
            self.physicsWorld.speed = 0.5
        }
        let wait = SKAction.wait(forDuration: 2)
        let slowMotionUp = SKAction.customAction(withDuration: 0.2) { (node, duration) in
            self.physicsWorld.speed = 1
        }
        let slowMotionSequence = SKAction.sequence([slowMotion, wait, slowMotionUp])
        
        run(slowMotionSequence)
    }
    
}

extension Level: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask | bodyB.categoryBitMask == Physics.Masks.ground | Physics.Masks.wheel ||
            bodyA.categoryBitMask | bodyB.categoryBitMask == Physics.Masks.ground | Physics.Masks.car) && car?.isJumping ?? false {
            car?.stopJump()
            car?.stopMoving()
            car?.startBreaking()
            setEndState()
        }
    }
    
}
