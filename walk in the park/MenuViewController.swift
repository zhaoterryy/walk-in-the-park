//
//  MenuViewController.swift
//  walk in the park
//
//  Created by ogura on 2018-03-14.
//  Copyright © 2018 ogura. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBAction func onStartBtnPressed(_ sender: UIButton) {
        if let sb = self.storyboard {
            let gvc = sb.instantiateViewController(withIdentifier: "Game")
            present(gvc, animated: true)
        }
    }
}
