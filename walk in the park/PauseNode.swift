//
//  PauseNode.swift
//  walk in the park
//
//  Created by ogura on 2018-03-14.
//  Copyright © 2018 ogura. All rights reserved.
//

import SpriteKit
import os.log

class SKPauseNode: SKNode {
    private let continueBtn : SKButtonNode
    private let mainMenuBtn : SKButtonNode
    private let gameOverBtn : SKButtonNode
    private let background : SKShapeNode
    private var mmCallback : (()->())?
    private var gameOverCallback : (()->())?
    
    required init?(coder aDecoder: NSCoder) {
        continueBtn = SKButtonNode(coder: aDecoder)!
        continueBtn.isUserInteractionEnabled = true
        mainMenuBtn = SKButtonNode(coder: aDecoder)!
        mainMenuBtn.isUserInteractionEnabled = true
        gameOverBtn = SKButtonNode(coder: aDecoder)!
        gameOverBtn.isUserInteractionEnabled = true
        background = SKShapeNode(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
    
    override init() {
        continueBtn = SKButtonNode(text: "continue", rectOf: CGSize(width: 280, height: 40), cornerRadius: 10.0)
        mainMenuBtn = SKButtonNode(text: "main menu", rectOf: CGSize(width: 280, height: 40), cornerRadius: 10.0)
        gameOverBtn = SKButtonNode(text: "game over", rectOf: CGSize(width: 280, height: 40), cornerRadius: 10.0)
        background = SKShapeNode(rectOf: CGSize(width:400, height:300), cornerRadius: 6.0)
        continueBtn.isUserInteractionEnabled = true

        super.init()
        
        continueBtn.onClick { [unowned self] () in
            self.isHidden = true
            self.scene?.isPaused = false
        }
        
        mainMenuBtn.onClick { [unowned self] () in
            self.mmCallback!()
        }
        
        gameOverBtn.onClick { [unowned self] () in
            self.gameOverCallback!()
        }
        
        isUserInteractionEnabled = true
        continueBtn.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        mainMenuBtn.isUserInteractionEnabled = true
        mainMenuBtn.position = CGPoint(x: frame.midX, y: frame.midY - 20)
        
        gameOverBtn.position = CGPoint(x: frame.midX, y: frame.midY - 90)
        gameOverBtn.isUserInteractionEnabled = true
        
        background.fillColor = .white
        background.zPosition = -1
        
        addChild(background)
        addChild(continueBtn)
        addChild(mainMenuBtn)
        addChild(gameOverBtn)
    }
    
    func onMainMenuPressed(_ completion: @escaping () -> ()) {
        self.mmCallback = completion
    }
    
    func onGameOverPressed(_ completion: @escaping () -> ()) {
        self.gameOverCallback = completion
    }
}
