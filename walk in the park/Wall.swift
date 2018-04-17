//
//  Wall.swift
//  walk in the park
//
//  Created by Tech on 2018-04-16.
//  Copyright © 2018 ogura. All rights reserved.
//

import Foundation
import SpriteKit

class Wall: SKNode {
    let wallSprite: SKSpriteNode
    
    var isInView: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        wallSprite = SKSpriteNode(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
    
    override init() {
        wallSprite = SKSpriteNode(color: .blue, size:CGSize(width: 400, height: 800))
        wallSprite.physicsBody = SKPhysicsBody(rectangleOf: wallSprite.size, center: CGPoint(x: wallSprite.size.width / 2, y: wallSprite.size.height / 2))
        wallSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        wallSprite.physicsBody?.isDynamic = true
        wallSprite.physicsBody?.mass = 1000
        
        super.init()
        addChild(wallSprite)
    }
    
}
