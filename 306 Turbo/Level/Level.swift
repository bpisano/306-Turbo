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
    
    private let leftCameraOffset: CGFloat = 50
    private let bottomCameraOffset: CGFloat = -50
    
    private var background: SKSpriteNode?
    private var middlePlan: SKSpriteNode?
    private var ambientLight: SKLightNode?
    private var state: LevelState = .start
        
    var backgroundTexture: SKTexture?
    var middlePlanTexture: SKTexture?
    var groundTexture: SKTexture?
    var lightColor: UIColor?
    var ambientLightColor: UIColor?
    
    var car: Car?
    var ground: Ground!
    var springboard: Springboard!
    
    var realSize: CGSize {
        guard let camera = camera else {
            return size
        }
        
        return CGSize(width: size.width * camera.xScale, height: size.height * camera.yScale)
    }
        
    override func didMove(to view: SKView) {
        configureGround()
        configureSpringboard()
        configureCar()
        configureCamera()
        configureTextures()
        configureLight()
        configureSun()
        configureContact()
        
        setStartState()
    }
    
    // MARK: - Init
    
    private func configureGround() {
        ground = Ground(from: self)
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
        camera.setScale(3)

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
        ambientLight?.position = camera?.position ?? CGPoint.zero
        
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
    
    private func updateCameraPosition() {
        guard let car = car else {
            return
        }
        
        let x = car.position.x + realSize.width / 2 - car.size.width / 2 - leftCameraOffset
        let y = car.position.y + realSize.height / 2 - car.size.height / 2 - ground.size.height - bottomCameraOffset
        let cameraPosition = CGPoint(x: x, y: y)
        
        camera?.position = cameraPosition
    }
    
    // MARK: - States
    
    func setStartState() {
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
        
        scene.scaleMode = .resizeFill
        view?.presentScene(scene)
        
        Configuration.shared.currentConfiguration?.incrementTime()
    }
    
    // MARK: - UI
    
    private func configureTextures() {
        guard let backgroundTexture = backgroundTexture else {
            return
        }
        
        background = Background(scene: self, texture: backgroundTexture)
        addChild(background!)
    }
    
    private func configureLight() {
        guard let ambientLightColor = ambientLightColor else {
            return
        }
        
        ambientLight = SKLightNode()
        ambientLight?.position = camera?.position ?? CGPoint.zero
        ambientLight?.falloff = 0.1
        ambientLight?.lightColor = lightColor ?? UIColor.white
        ambientLight?.ambientColor = ambientLightColor
        ambientLight?.categoryBitMask = Light.Masks.ambient
        
        addChild(ambientLight!)
    }
    
    private func configureSun() {
        guard let background = background, Configuration.shared.currentConfiguration?.time == .afternoon else {
            return
        }
        
        let sunSize = CGSize(width: 652, height: 652)
        let sunPosition = CGPoint(x: 0, y: -realSize.height / 2 + ground.size.height / 2 + sunSize.height / 2)
        let sunTexture = SKTexture(imageNamed: "Sun")
        let sun = SKSpriteNode(texture: sunTexture, color: UIColor.clear, size: sunSize)
        
        sun.position = sunPosition
        sun.zPosition = 10
        
        background.addChild(sun)
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
