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
        initGameScene()
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
    
    func resetGame() {
        initGameScene()
    }
    
    private func initGameScene() {
        if let view = self.view as! SKView? {
            let gs = GameScene(size: view.bounds.size)
            
            // Set the scale mode to scale to fit the window
            gs.scaleMode = .aspectFill
            
            gs.onMainMenuPressed { [unowned self] () in
                self.dismiss(animated: true)
            }
            
            gs.onGameOverPressed { [unowned self] (_ score:String) in
                if let sb = self.storyboard {
                    if let lvc = sb.instantiateViewController(withIdentifier: "End") as? LoseViewController {
                        self.present(lvc, animated: true)
                        if let lbl = lvc.lblTimer {
                            lbl.text = "Score: " + score
                        }
                    }
                }
            }
            // Present the scene
            view.presentScene(gs)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
}
