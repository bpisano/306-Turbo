//
//  Map.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 03/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SpriteKit
import GameplayKit

class Map: SKScene {
    
    private var canUpdateCameraPosition: Bool = true
    
    var car: Car!
    var ground: Ground!
    var springboard: Springboard!
        
    override func didMove(to view: SKView) {
        configureGround()
        configureCar()
        configureSpringboard()
        configureCamera()
        configureContact()
    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        car.moveForward()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        car.stopMoving()
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateCameraPosition()
        
        if car.position.x > 5000 && car.position.x < 5100 {
            car.jump()
        }
    }
    
    // MARK: - Camera
    
    private func defaultCameraPosition() -> CGPoint {
        return CGPoint(x: car.position.x + size.width / 2 - car.size.width / 2 - 20, y: car.position.y + size.height / 2 - car.size.height - 100)
    }
    
    private func carCameraPosition() -> CGPoint {
        return car.position
    }
    
    private func updateCameraPosition() {
        if canUpdateCameraPosition {
            camera?.position = defaultCameraPosition()
        }
    }
    
    // MARK: - Animation
    
    private func endAnimation() {
        let wait = SKAction.wait(forDuration: 2)
        
        let slowMotion = SKAction.customAction(withDuration: 0.2) { (node, duration) in
            self.physicsWorld.speed = 0.1
            self.canUpdateCameraPosition = false
        }
        let slowMotionUp = SKAction.customAction(withDuration: 0.2) { (node, duration) in
            self.physicsWorld.speed = 1
        }
        let slowMotionSequence = SKAction.sequence([slowMotion, wait, slowMotionUp])
        
        let cameraZoom = SKAction.scale(to: 1, duration: 0.2)
        let cameraCarPosition = SKAction.move(to: carCameraPosition(), duration: 0.2)
        let cameraFirstGroup = SKAction.group([cameraZoom, cameraCarPosition])
        let cameraZoomOut = SKAction.scale(to: 1.5, duration: 0.2)
        let cameraDefaultPosition = SKAction.move(to: defaultCameraPosition(), duration: 0.2)
        let cameraSecondGroup = SKAction.group([cameraZoomOut, cameraDefaultPosition])
        let cameraCompletion = SKAction.customAction(withDuration: 0.1) { (node, duration) in
            self.canUpdateCameraPosition = true
        }
        let camersaSequence = SKAction.sequence([cameraFirstGroup, wait, cameraSecondGroup, cameraCompletion])
        
        camera?.run(camersaSequence)
        run(slowMotionSequence)
    }
    
}

extension Map: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask | bodyB.categoryBitMask == Physics.Masks.ground | Physics.Masks.wheel && car.isJumping {
            car.stopJump()
            car.startBreaking()
            endAnimation()
        }
    }
    
}
