//
//  ButtonNode.swift
//  walk in the park
//
//  Created by ogura on 2018-03-14.
//  Copyright © 2018 ogura. All rights reserved.
//

import SpriteKit
import os.log

class SKButtonNode: SKNode {
    private let label : SKLabelNode
    private let box : SKShapeNode
    private var action : (()->())?
    
    required init?(coder aDecoder: NSCoder) {
        label = SKLabelNode(coder: aDecoder)!
        box = SKShapeNode(coder: aDecoder)!
        action = nil
        super.init(coder: aDecoder)
    }
    
    init(text: String, rectOf: CGSize, cornerRadius: CGFloat, clicked: (() -> ())? = nil) {        
        label = SKLabelNode(text: text)
        box = SKShapeNode(rectOf: rectOf, cornerRadius: cornerRadius)
        action = clicked
        super.init()
        isUserInteractionEnabled = true
        label.fontColor = .black
        label.verticalAlignmentMode = .center
        box.strokeColor = .black
        addChild(box)
        box.addChild(label)
    }
    
    func onClick(_ onClick: @escaping () -> ()) {
        self.action = onClick
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            box.contains(touch.location(in: self))
            action!()
        }
    }
}
