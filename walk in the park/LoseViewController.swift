//
//  LoseViewController.swift
//  walk in the park
//
//  Created by ogura on 2018-03-26.
//  Copyright © 2018 ogura. All rights reserved.
//

import UIKit

class LoseViewController: UIViewController {
    
//    @IBAction func onStartBtnPressed(_ sender: UIButton) {
//        if let sb = self.storyboard {
//            let gvc = sb.instantiateViewController(withIdentifier: "Game")
//            present(gvc, animated: true)
//        }
//    }
    @IBAction func onMainMenuBtnPressed(_ sender: Any) {
//        if let sb = self.storyboard {
        view.window!.rootViewController?.dismiss(animated: true)
//        }
    }
    @IBAction func onRetryBtnPressed(_ sender: Any) {
        self.dismiss(animated: false)
    }
}
