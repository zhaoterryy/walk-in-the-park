//
//  GameViewController.swift
//  walk in the park
//
//  Created by ogura on 2018-03-14.
//  Copyright © 2018 ogura. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let gameScene = GameScene(size: view.bounds.size)
            
            // Set the scale mode to scale to fit the window
            gameScene.scaleMode = .aspectFill
            
            gameScene.onMainMenuPressed { [unowned self] () in
                self.dismiss(animated: true)
            }
            
            gameScene.onGameOverPressed { [unowned self] () in
                if let sb = self.storyboard {
                    let gameOverVc = sb.instantiateViewController(withIdentifier: "End")
                    self.present(gameOverVc, animated: true)
                }
            }
            // Present the scene
            view.presentScene(gameScene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
