//
//  GameScene.swift
//  walk in the park
//
//  Created by ogura on 2018-03-14.
//  Copyright © 2018 ogura. All rights reserved.
//

import SpriteKit
import os.log

class GameScene: SKScene {
    private let pauseMenu: SKPauseNode
    private let pauseBtn: SKSpriteNode
    private let playerCamera: SKCameraNode
    private let player: SKSpriteNode
    private let playerRoot: SKNode
    private let playerGroundCheck: SKNode
    private let ground: SKSpriteNode
    private let coin: SKSpriteNode
    private let scoreLabel: SKLabelNode
    private var gameOverCallback : ((_ score:String)->())?
    
    private let wall1: Wall
    private let wall2: Wall
    
    private var isInAir: Bool = false
    private var score: Int = 0
    private var elapsedTime: TimeInterval
    
    private let standingTextures : [SKTexture] = [
        SKTexture(image:#imageLiteral(resourceName: "s1")), SKTexture(image:#imageLiteral(resourceName: "s2")), SKTexture(image:#imageLiteral(resourceName: "s3")),
        SKTexture(image:#imageLiteral(resourceName: "s4")), SKTexture(image:#imageLiteral(resourceName: "s5")), SKTexture(image:#imageLiteral(resourceName: "s6"))
    ]
    private let walkingTextures : [SKTexture] = [
        SKTexture(image:#imageLiteral(resourceName: "w1")), SKTexture(image:#imageLiteral(resourceName: "w2")), SKTexture(image:#imageLiteral(resourceName: "w3")),
        SKTexture(image:#imageLiteral(resourceName: "w4")), SKTexture(image:#imageLiteral(resourceName: "w5")), SKTexture(image:#imageLiteral(resourceName: "w6"))
    ]
    
    private let coinsnd = SKAction.playSoundFileNamed("coinsnd", waitForCompletion: false)
    private let jumpsnd = SKAction.playSoundFileNamed("jumpsnd", waitForCompletion: false)
    private let btnsnd = SKAction.playSoundFileNamed("btnsnd", waitForCompletion: false)
    
    private struct PhysicsCategory {
        static let player: UInt32 = 0x01
        static let worldStatic: UInt32 = 0x02
        static let playerGroundCheck: UInt32 = 0x04
        static let pickUp: UInt32 = 0x08
        static let wall: UInt32 = 0x16
    }
    
    required init?(coder aDecoder: NSCoder) {
        pauseMenu = SKPauseNode(coder: aDecoder)!
        pauseBtn = SKSpriteNode(coder: aDecoder)!
        playerCamera = SKCameraNode(coder: aDecoder)!
        player = SKSpriteNode(coder: aDecoder)!
        ground = SKSpriteNode(coder: aDecoder)!
        playerRoot = SKNode(coder: aDecoder)!
        playerGroundCheck = SKNode(coder: aDecoder)!
        wall1 = Wall(coder: aDecoder)!
        wall2 = Wall(coder: aDecoder)!
        coin = SKSpriteNode(coder: aDecoder)!
        scoreLabel = SKLabelNode(coder: aDecoder)!
        elapsedTime = 0.0
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        pauseMenu = SKPauseNode()
        pauseBtn = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "MenuButton")))
        playerCamera = SKCameraNode()
        player = SKSpriteNode(texture: standingTextures[0])
        ground = SKSpriteNode(color: .brown, size: CGSize(width: 100000, height: 2500))
        playerRoot = SKNode()
        playerGroundCheck = SKNode()
        wall1 = Wall()
        wall1.wallSprite.physicsBody?.categoryBitMask = PhysicsCategory.wall
        wall1.wallSprite.physicsBody?.categoryBitMask |= PhysicsCategory.worldStatic
        wall1.wallSprite.physicsBody?.contactTestBitMask = PhysicsCategory.pickUp
        wall2 = Wall()
        wall2.wallSprite.physicsBody?.categoryBitMask = PhysicsCategory.wall
        wall2.wallSprite.physicsBody?.categoryBitMask |= PhysicsCategory.worldStatic
        wall2.wallSprite.physicsBody?.contactTestBitMask = PhysicsCategory.pickUp
        coin = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "Star")))
        scoreLabel = SKLabelNode(text: nil)
        elapsedTime = 0.0
        super.init(size: size)
        
        backgroundColor = .white
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -50)
        physicsWorld.contactDelegate = self
        playerCamera.setScale(10.0)
        
        pauseMenu.isHidden = true
        pauseMenu.zPosition = 10
        
        pauseBtn.scale(to: CGSize(width: 50, height: 50))
        pauseBtn.color = .black
        pauseBtn.colorBlendFactor = 1.0
        pauseBtn.zPosition = 5

        playerRoot.position = CGPoint(x: 3750, y: 0)
        playerRoot.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: 1000.0, dy: 0.0), duration: 1.0)), withKey: "moving")
        playerRoot.physicsBody?.mass = 5;
        playerRoot.addChild(player)
        playerRoot.addChild(playerCamera)
        
        player.position = CGPoint(x: 0, y: 0)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        player.run(SKAction.repeatForever(SKAction.animate(with: walkingTextures, timePerFrame: 0.08)), withKey: "standingAni")
        player.zPosition = -1
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size, center: CGPoint(x: 0.0, y: player.size.height / 2))
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.collisionBitMask = PhysicsCategory.worldStatic
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.restitution = 0.1
        player.addChild(playerGroundCheck)
        
        playerGroundCheck.position = CGPoint(x: 0, y: 0)
        playerGroundCheck.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width / 2, height: 50.0), center: CGPoint(x: 0.0, y: -25.0))
        playerGroundCheck.physicsBody?.categoryBitMask = PhysicsCategory.playerGroundCheck
        playerGroundCheck.physicsBody?.contactTestBitMask = PhysicsCategory.worldStatic
        playerGroundCheck.physicsBody?.collisionBitMask = 0
        playerGroundCheck.physicsBody?.isDynamic = true
        playerGroundCheck.physicsBody?.affectedByGravity = false
        
        playerCamera.position = CGPoint(x: 4000, y: 1000)
        let camMoveAction = SKAction.move(to: CGPoint(x: 2000, y: 1000), duration: 5.0)
        camMoveAction.timingMode = .easeInEaseOut
        playerCamera.run(camMoveAction)

        pauseBtn.position = CGPoint(x: 330, y: 168)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size, center: CGPoint(x: ground.size.width / 2, y: -ground.size.height / 2))
        ground.position = CGPoint(x: 0.0, y: 0.0)
        ground.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        ground.physicsBody?.categoryBitMask = PhysicsCategory.worldStatic
        ground.physicsBody?.isDynamic = false
        ground.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: 1000.0, dy: 0.0), duration: 1.0)), withKey: "moving")

        coin.position = CGPoint(x:9000, y:250)
        coin.zPosition = -1
        coin.scale(to:CGSize(width: 425, height:500))
        coin.physicsBody = SKPhysicsBody(circleOfRadius: 250)
        coin.physicsBody?.categoryBitMask = PhysicsCategory.pickUp
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.player
        coin.physicsBody?.collisionBitMask = 0
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.isDynamic = true
        
        scoreLabel.position = CGPoint(x:-310, y:175)
        scoreLabel.zPosition = 1
        scoreLabel.fontSize = CGFloat(30)
        scoreLabel.fontColor = .black
        scoreLabel.text = "Score: \(score)"
        
        self.camera = playerCamera
        playerCamera.addChild(pauseMenu)
        playerCamera.addChild(pauseBtn)
        playerCamera.addChild(scoreLabel)
        addChild(playerRoot)
        addChild(ground)
        addChild(wall1)
        addChild(wall2)
        addChild(coin)
        
        spawnJumpWall(wall: wall1)
        spawnJumpWall(wall: wall2, additionalOffset: 4000.0)
        
    }
    
    func onMainMenuPressed(_ completion: @escaping () -> ()) {
        pauseMenu.onMainMenuPressed(completion)
    }
    
    func onGameOverPressed(_ completion: @escaping (_ score:String) -> ()) {
        self.gameOverCallback = completion;
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(_ t : UITouch) {
        let pos = t.location(in:playerCamera)
//        os_log("%@", type:.debug, pos.debugDescription)
        
        if isPaused {
            if !pauseMenu.contains(pos) {
                pauseMenu.isHidden = true
                isPaused = false
            }
            return
        }

        if pauseBtn.contains(pos) {
            pauseMenu.isHidden = false
            isPaused = true
            run(btnsnd)
            return
        }
        if !isInAir {
            player.physicsBody?.velocity = CGVector(dx: 0.0, dy: 4000.0)
            run(jumpsnd)
            isInAir = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(t) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(t) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        checkDeath()
        checkWallInView(wall: wall1)
        checkWallInView(wall: wall2)
        
        if (!playerCamera.contains(coin) && coin.position.x < playerRoot.position.x)
        {
            let MoveAction = SKAction.moveTo(x: playerRoot.position.x + 8000, duration: 0)
            coin.run(MoveAction)
        }

        playerRoot.action(forKey: "moving")?.speed += 0.001
        ground.action(forKey: "moving")?.speed += 0.001
        elapsedTime += currentTime
    }
    
    func CheckOverlap()
    {
        let MoveAction = SKAction.moveTo(x: coin.position.x + 1000, duration: 0)
        coin.run(MoveAction)
    }
    
    func checkDeath() {
        if (playerRoot.position.x > 10000 && !playerCamera.contains(player) && gameOverCallback != nil) {
            gameOverCallback!(score.description)
            gameOverCallback = nil
        }
    }
    
    func checkWallInView(wall: Wall) {
        if (wall.isInView && wall.wallSprite.position.x < playerRoot.position.x - 3000) {
            wall.isInView = false
            spawnJumpWall(wall: wall)
        }
    }
    
    func spawnJumpWall(wall: Wall, additionalOffset: CGFloat = 0) {
        let randSecs = arc4random_uniform(UInt32(3))
        _ = Timer.scheduledTimer(withTimeInterval: Double(randSecs), repeats: false) { timer in
            wall.wallSprite.position = CGPoint(x: self.playerRoot.position.x + 9000 + additionalOffset, y: 0)
            wall.isInView = true;
        }

    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        playerGroundCheck.position = CGPoint(x: 0, y: 0)
    }
}
var _contactCount = 0
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsCategory.playerGroundCheck || contact.bodyB.categoryBitMask == PhysicsCategory.playerGroundCheck {
         isInAir = false
        }

        if contact.bodyA.categoryBitMask == PhysicsCategory.player || contact.bodyB.categoryBitMask == PhysicsCategory.player {
            if contact.bodyA.categoryBitMask == PhysicsCategory.pickUp || contact.bodyB.categoryBitMask == PhysicsCategory.pickUp {
                score += 1
                scoreLabel.text = "Score:\(score)"
                let MoveAction = SKAction.moveTo(x: playerRoot.position.x + 8000, duration: 0)
                contact.bodyB.node?.run(MoveAction)
                run(coinsnd)
            }
        }
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.wall || contact.bodyB.categoryBitMask == PhysicsCategory.wall {
            if contact.bodyA.categoryBitMask == PhysicsCategory.pickUp || contact.bodyB.categoryBitMask == PhysicsCategory.pickUp {
                CheckOverlap()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsCategory.playerGroundCheck || contact.bodyB.categoryBitMask == PhysicsCategory.playerGroundCheck {
            isInAir = true
        }
    }
}
