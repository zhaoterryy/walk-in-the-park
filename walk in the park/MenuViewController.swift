//
//  MenuViewController.swift
//  walk in the park
//
//  Created by ogura on 2018-03-14.
//  Copyright © 2018 ogura. All rights reserved.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController {
    var player: AVAudioPlayer?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.setVolume(1.0, fadeDuration: 1.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sound = NSDataAsset(name: "BGM") {
            do {
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try! AVAudioSession.sharedInstance().setActive(true)
                
                try player = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
                player?.play()
                player?.numberOfLoops = -1
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    @IBAction func onStartBtnPressed(_ sender: UIButton) {
        if let sb = self.storyboard {
            player?.setVolume(0.3, fadeDuration: 1.0)
            let gvc = sb.instantiateViewController(withIdentifier: "Game")
            present(gvc, animated: true)
        }
    }
}
