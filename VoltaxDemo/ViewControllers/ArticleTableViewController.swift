//
//  ArticleTableViewController.swift
//  VoltaxDemo
//
//  Created by Alon Shprung on 14/02/2021.
//

import Foundation
import UIKit
import VoltaxSDK

class ArticleTableViewController: UITableViewController {
    
    let imageHeaderCellReuseIdentifier = "imageHeaderTableViewCell"
    let textHeaderCellReuseIdentifier = "textHeaderTableViewCell"
    let contentCellReuseIdentifier = "contentTableViewCell"
    let mmWrapperCellReuseIdentifier = "mmWrapperTableViewCell"
    
    var mmVideoView: MMVideoView? = nil
    var mmVideoViewCellHeight: CGFloat = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let mmVideoView = self.mmVideoView {
            mmVideoView.viewWillTransition(coordinator);
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: imageHeaderCellReuseIdentifier, for: indexPath)
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: textHeaderCellReuseIdentifier, for: indexPath)
            break
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: mmWrapperCellReuseIdentifier, for: indexPath)
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: contentCellReuseIdentifier, for: indexPath)
        }
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = tableView.frame.size.width
        var height: CGFloat = 0
        switch indexPath.row {
        case 0:
            height = 0.5625*width
            break
        case 1:
            height = 120
            break
        case 3:
            height = self.mmVideoViewCellHeight
            break
        default:
            height = UIDevice.current.orientation.isLandscape ? 230 : 350
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 3 { // MM video view item
            if (self.mmVideoView == nil) {
                setupVideoView(containerView: cell.contentView)
            } else {
                self.mmVideoView?.willDisplay()
            }
        }
    }
    
    func setupVideoView(containerView: UIView) {
        let playerId = "01dnemrsc8vhsc1y4t" // or "01dnevbq6gva107mjc"
        let contentId = "01en8ftr9pp38x78qa" // or "01ewfqp7dxa0egkh62" with read more
        self.mmVideoView = MMVideoView(playerId: playerId, contentId: contentId)
        self.mmVideoView?.delegate = self
        self.mmVideoView?.load(containerView)
    }
}

extension ArticleTableViewController: MMVideoViewDelegate {
    func mmVideoViewHeight(_ height: CGFloat) {  // Remove this for 16:9 resolution
        self.mmVideoViewCellHeight = height
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}
