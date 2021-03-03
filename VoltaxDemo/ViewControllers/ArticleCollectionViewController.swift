//
//  ArticleCollectionViewController.swift
//  VoltaxDemo
//
//  Created by Alon Shprung on 24/01/2021.
//

import Foundation
import UIKit
import VoltaxSDK

class ArticleCollectionViewController: UICollectionViewController {
    
    let imageHeaderCellReuseIdentifier = "imageHeaderCollectionCell"
    let textHeaderCellReuseIdentifier = "textHeaderCollectionCell"
    let contentCellReuseIdentifier = "contentCollectionCell"
    let mmWrapperCellReuseIdentifier = "mmWrapperCollectionCell"
    
    var mmVideoView: MMVideoView? = nil
    var mmVideoViewCellHeight: CGFloat = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
        if let mmVideoView = self.mmVideoView {
            mmVideoView.viewWillTransition(coordinator);
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ArticleCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // create a new cell if needed or reuse an old one
        var cell: UICollectionViewCell?
        
        switch indexPath.row {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageHeaderCellReuseIdentifier, for: indexPath)
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: textHeaderCellReuseIdentifier, for: indexPath)
        case 3:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: mmWrapperCellReuseIdentifier, for: indexPath)
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellReuseIdentifier, for: indexPath)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == 3 { // MM video view item
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

// MARK: - UICollectionViewDelegateFlowLayout
extension ArticleCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width
        
        switch indexPath.row {
        case 0:
            return CGSize(width: width, height: 0.5625*width)
        case 1:
            return CGSize(width: width, height: 120)
        case 2,4:
            return CGSize(width: width, height: UIDevice.current.orientation.isLandscape ? 200 : 350)
        case 3:
//            return CGSize(width: width, height: width / (16.0 / 9.0))  // For 16:9 resolution
            return CGSize(width: width, height: mmVideoViewCellHeight)
        default:
            break
        }
        return CGSize(width: width, height: UIDevice.current.orientation.isLandscape ? 200 : 350)
    }
}

extension ArticleCollectionViewController: MMVideoViewDelegate {
    func mmVideoViewHeight(_ height: CGFloat) {  // Remove this for 16:9 resolution
        self.mmVideoViewCellHeight = height
        self.collectionView.performBatchUpdates(nil, completion: nil)
    }
}
