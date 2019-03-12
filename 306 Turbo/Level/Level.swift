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
    
    private var currentUI: UIProtocol?
    private var background: SKSpriteNode?
    private var middlePlan: SKSpriteNode?
    private var ambientLight: SKLightNode?
    private var state: LevelState = .start
    
    private var distance: Int = 0
    private var height: Int = 0
        
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
        
        set(state: .start)
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
        currentUI?.update(from: self)
        
        updateCameraPosition()
        background?.position = camera?.position ?? CGPoint.zero
        ambientLight?.position = camera?.position ?? CGPoint.zero
        
        if let car = car, car.position.x > springboard.position.x + springboard.size.width / 2 && !car.isJumping && state == .driving {
            car.jump()
        }
        
        if let car = car, car.isJumping {
            let currentHeight = Maths.meterPositionFrom(position: car.position, springBoardPosition: springboard.position).y
            height = max(height, Int(currentHeight))
        }
    }
    
    // MARK: - Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let car = car else {
            return
        }
        
        switch state {
        case .start:
            set(state: .driving)
        case .driving:
            car.moveForward()
        case .end:
            restart()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        if let car = car, touch.force > 4 && state == .driving && car.haveBoost {
            TapticEngine.feedback(style: .light)
            car.boost()
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
    
    func set(state newState: LevelState) {
        switch state {
        case .start:
            setStartState()
        case .driving:
            setDrivingState()
        case .end:
            setEndState()
        }
        
        state = newState
        configureUI()
    }
    
    private func setStartState() {
        
    }
    
    private func setDrivingState() {
        
    }
    
    private func setEndState() {
        let label = SKLabelNode(text: "End")
        label.name = "label"
        camera?.addChild(label)
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
    
    private func configureUI() {
        currentUI?.remove()
        
        switch state {
        case .start:
            currentUI = StartUI(scene: self)
        case .driving:
            currentUI = DriveUI(scene: self)
        case .end:
            currentUI = EndUI(distance: distance, height: height)
            Configuration.shared.currentConfiguration?.update(distance: distance, height: height)
        }
        
        if let currentUI = currentUI {
            camera?.addChild(currentUI.node)
        }
    }
    
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
        
        if bodyA.categoryBitMask | bodyB.categoryBitMask == Physics.Masks.ground | Physics.Masks.wheel && car?.isJumping ?? false {
            if let car = car {
                distance = Int(Maths.meterPositionFrom(position: car.position, springBoardPosition: springboard.position).x)
            }
                        
            TapticEngine.feedback(style: .medium)
            
            car?.stopJump()
            car?.stopMoving()
            car?.startBreaking()
            
            set(state: .end)
        } else if bodyA.categoryBitMask | bodyB.categoryBitMask == Physics.Masks.ground | Physics.Masks.car && car?.isJumping ?? false {
            TapticEngine.feedback(style: .heavy)
        }
    }
    
}
