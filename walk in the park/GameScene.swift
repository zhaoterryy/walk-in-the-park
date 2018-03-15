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

    private let pauseMenu : SKPauseNode
    private let pauseBtn : SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        pauseMenu = SKPauseNode(coder: aDecoder)!
        pauseBtn = SKSpriteNode(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        pauseMenu = SKPauseNode()
//        pauseBtn = SKButtonNode(text: "pause", rectOf: CGSize(width: 140, height: 40), cornerRadius: 10)
        pauseBtn = SKSpriteNode(imageNamed: "MenuButton")
        
        super.init(size: size)

        pauseMenu.position = CGPoint(x: frame.midX, y: frame.midY)
        pauseMenu.isHidden = true
        
        pauseBtn.position = CGPoint(x: size.width - 45, y: size.height - 45)
        pauseBtn.scale(to: CGSize(width: 50, height: 50))
        
        addChild(pauseMenu)
        addChild(pauseBtn)
    }
    
    func onMainMenuPressed(_ completion: @escaping () -> ()) {
        pauseMenu.onMainMenuPressed(completion)
    }
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
        

    }
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
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
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
