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
    
    fileprivate var handler: MMIMAAdsProvider?
    
    lazy var mmVideoView: MMVideoView = {
        let playerId = "01fqtx7qpnayc5zbtw" // or "01dnevbq6gva107mjc"
        let contentId = "01en8ftr9pp38x78qa" // or "01dnevbq6gva107mjc"
        return MMVideoView(playerId: playerId, contentId: contentId)
    }()
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func playButtonClicked(_ sender: Any) {
        mmVideoView.play()
        
    }
    
    @IBAction func pauseButtonClicked(_ sender: Any) {
        mmVideoView.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set handler to mmVideoView
        handler = MMIMAAdsHandler(vc: self)
        mmVideoView.adsProvider = handler
        
        mmVideoView.delegate = self
        
        mmVideoView.load(mmVideoViewContainer)
    }
}

extension VideoViewController: MMVideoViewDelegate {
    func onPlayerLoaded() {
        statusLabel.text = "Player Loaded!"
    }
    
    func onPlayerError(_ error: MMVideoViewError) {
        let message: String = error.message as String
        let code: Int = error.code.intValue
        let isFatalError = error.isFatalError
        print("ERROR: " + message)
    }
}
