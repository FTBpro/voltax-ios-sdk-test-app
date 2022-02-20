//
//  MMIMAAdsHandler.swift
//  VoltaxDemo
//
//  Created by Alon Shprung on 16/01/2022.
//

import Foundation
import GoogleInteractiveMediaAds
import VoltaxSDK
import UIKit

class MMIMAAdsHandler: NSObject, MMIMAAdsProvider {
    var delegate: MMIMAAdsProviderDelegate?
    
    weak var vc: UIViewController? = nil
    
    private var adsLoader: IMAAdsLoader!
    private var adsManager: IMAAdsManager!
    
    private var adDisplayContainer: UIView?
    
    private var soundOnOffView: UIView?
    
    init(vc: UIViewController) {
        self.vc = vc
        super.init()
        
        self.setUpAdsLoader()
    }
    
    func setUpAdsLoader() {
      adsLoader = IMAAdsLoader(settings: nil)
      adsLoader.delegate = self
    }
    
    func requestAds(in view: UIView, with tagUrl: String) {
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(
          adContainer: view, viewController: vc, companionSlots: nil)
        self.adDisplayContainer = view
        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
          adTagUrl: tagUrl,
          adDisplayContainer: adDisplayContainer,
          contentPlayhead: nil,
          userContext: nil)

        adsLoader.requestAds(with: request)
    }
    
    func isPlaying() -> Bool {
        return adsManager?.adPlaybackInfo.isPlaying ?? false
    }
    
    func isMuted() -> Bool {
        return adsManager?.volume == 0
    }
    
    func requestAdsManager(to task: MMIMAAdsManagerTask) {
        guard let adsManager = self.adsManager else { return }
        switch task {
        case .ADS_MANAGER_START:
            adsManager.start()
            break
        case .ADS_MANAGER_PAUSE:
            adsManager.pause()
            break
        case .ADS_MANAGER_RESUME:
            adsManager.resume()
            break
        case .ADS_MANAGER_MUTE:
            adsManager.volume = 0
            break
        case .ADS_MANAGER_UNMUTE:
            adsManager.volume = 1
            break
        @unknown default:
            break
        }
    }
    
    private func addSoundOnOffView() {
        if (self.soundOnOffView == nil) {
            let view = UIView()
            
            self.vc?.view.addSubview(view)
            
            delegate?.handleSound(view)
            
            self.soundOnOffView = view
            
            view.translatesAutoresizingMaskIntoConstraints = false
            self.vc?.view.addConstraints([
                view.topAnchor.constraint(equalTo: self.adDisplayContainer!.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.adDisplayContainer!.leadingAnchor),
                view.widthAnchor.constraint(equalToConstant: 44.0),
                view.heightAnchor.constraint(equalToConstant: 44.0)
            ])
        }
    }
}

// MARK: - IMAAdsLoaderDelegate

extension MMIMAAdsHandler: IMAAdsLoaderDelegate {
    func adsLoader(_ loader: IMAAdsLoader, adsLoadedWith adsLoadedData: IMAAdsLoadedData) {
        // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
        adsManager = adsLoadedData.adsManager
        adsManager.delegate = self

        // Create ads rendering settings and tell the SDK to use the in-app browser.
        let adsRenderingSettings = IMAAdsRenderingSettings()
        adsRenderingSettings.linkOpenerPresentingController = vc

        // Initialize the ads manager.
        adsManager.initialize(with: adsRenderingSettings)
    }
    
    func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {
        delegate?.adsLoaderDidRecieveError(adErrorData.adError.message)
    }
}

// MARK: - IMAAdsManagerDelegate

extension MMIMAAdsHandler: IMAAdsManagerDelegate {
    func adsManager(_ adsManager: IMAAdsManager, didReceive event: IMAAdEvent) {
        var mmAdEvent: MMIMAAdEvent? = nil
        guard let ad = event.ad else { return }
        
        switch event.type {
        case .LOADED:
            mmAdEvent = .EVENT_LOADED
            break
        case .PAUSE:
            mmAdEvent = .EVENT_PAUSE
            break
        case .RESUME:
            mmAdEvent = .EVENT_RESUME
            break
        case .TAPPED:
            mmAdEvent = .EVENT_TAPPED
            break
        case .CLICKED:
            mmAdEvent = .EVENT_CLICKED
            break
        case .COMPLETE:
            mmAdEvent = .EVENT_COMPLETE
            break
        case .STARTED:
            mmAdEvent = .EVENT_STARTED
            if (ad.contentType != "application/javascript") {
                self.addSoundOnOffView()
            }
            break
        case .SKIPPED:
            mmAdEvent = .EVENT_SKIPPED
            break
        case .FIRST_QUARTILE:
            mmAdEvent = .EVENT_FIRST_QUARTILE
            break
        case .THIRD_QUARTILE:
            mmAdEvent = .EVENT_THIRD_QUARTILE
            break
        case .MIDPOINT:
            mmAdEvent = .EVENT_MIDPOINT
            break
        default:
            break
        }
        if let mmAdEvent = mmAdEvent {
            let adObject = MMIMAAd(currentPosition: adsManager.adPlaybackInfo.currentMediaTime, duration: ad.duration, adPosition: Int32(ad.adPodInfo.adPosition), contentType: ad.contentType)
            
            delegate?.adsManagerDidRecieveEvent(mmAdEvent, ad: adObject)
        }
    }
    
    func adsManager(_ adsManager: IMAAdsManager, didReceive error: IMAAdError) {
        delegate?.adsManagerDidRecieveError(error.message)
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {
        delegate?.adsManagerDidRequestContentPause()
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {
        delegate?.adsManagerDidRequestContentResume()
        self.soundOnOffView?.removeFromSuperview()
        self.soundOnOffView = nil
    }
}
