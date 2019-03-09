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
    
    private var background: SKSpriteNode?
    private var middlePlan: SKSpriteNode?
    private var ambientLight: SKLightNode?
    private var state: LevelState = .start
    
    var backgroundTexture: SKTexture?
    var middlePlanTexture: SKTexture?
    var groundTexture: SKTexture?
    var ambientLightColor: UIColor?
    
    var car: Car?
    var ground: Ground!
    var springboard: Springboard!
        
    override func didMove(to view: SKView) {
        Configuration.shared.currentConfiguration?.incrementTime()
        
        configureGround()
        configureSpringboard()
        configureCamera()
        configureTextures()
        configureLight()
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
        background?.position = camera?.position ?? CGPoint.zero
        let y = camera?.position.y ?? 0
        ambientLight?.position = CGPoint(x: camera?.position.x ?? 0, y: y)
        
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
            restart()
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
    
    func restart() {
        guard let scene = SKScene(fileNamed: name ?? "") else {
            return
        }
        
        scene.scaleMode = .aspectFill
        view?.presentScene(scene)
    }
    
    // MARK: - UI
    
    private func configureTextures() {
        if let backgroundTexture = backgroundTexture {
            let cameraScaleX = camera?.xScale ?? 1
            let cameraScaleY = camera?.yScale ?? 1
            var backgroundSize = CGSize(width: size.width * cameraScaleX, height: size.height * cameraScaleY)
            
            if backgroundSize.width > backgroundSize.height {
                backgroundSize = CGSize(width: backgroundSize.width, height: backgroundSize.width)
            } else {
                backgroundSize = CGSize(width: backgroundSize.height, height: backgroundSize.height)
            }
            
            background = SKSpriteNode(texture: backgroundTexture, color: UIColor.clear, size: backgroundSize)
            background?.zPosition = -1000
            
            addChild(background!)
        }
    }
    
    private func configureLight() {
        guard let ambientLightColor = ambientLightColor else {
            return
        }
        
        ambientLight = SKLightNode()
        ambientLight?.position = CGPoint(x: 0, y: size.height * (camera?.yScale ?? 1))
        ambientLight?.falloff = 0.1
        ambientLight?.ambientColor = ambientLightColor
        ambientLight?.categoryBitMask = Light.Masks.ambient
        
        addChild(ambientLight!)
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
