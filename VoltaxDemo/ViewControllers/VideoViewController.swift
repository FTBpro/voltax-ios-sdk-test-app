//
//  VideoViewController.swift
//  VoltaxDemo
//
//  Created by Alon Shprung on 28/01/2021.
//

import UIKit
import VoltaxSDK

class VideoViewController: UIViewController {
    @IBOutlet weak var mmVideoViewContainer: UIView!
    
    let mmVideoView: MMVideoView = {
        let playerId = "01dnemrsc8vhsc1y4t" // or "01dnevbq6gva107mjc"
        let contentId = "01en8ftr9pp38x78qa" // or "01dnevbq6gva107mjc"
        return MMVideoView(playerId: playerId, contentId: contentId)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mmVideoView.load(mmVideoViewContainer)
    }
}

