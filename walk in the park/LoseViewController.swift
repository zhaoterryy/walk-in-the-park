//
//  LoseViewController.swift
//  walk in the park
//
//  Created by ogura on 2018-03-26.
//  Copyright © 2018 ogura. All rights reserved.
//

import UIKit

class LoseViewController: UIViewController {
    
    @IBOutlet var lblTimer: UILabel!
    
    @IBAction func onMainMenuBtnPressed(_ sender: Any) {
        view.window!.rootViewController?.dismiss(animated: true)
    }
    
    @IBAction func onRetryBtnPressed(_ sender: Any) {
        if let gvc = presentingViewController as? GameViewController {
            gvc.resetGame()
        }
        self.dismiss(animated: false)
    }
}
