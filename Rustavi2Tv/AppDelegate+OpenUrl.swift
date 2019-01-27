//
//  AppDelegate+OpenUrl.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 1/27/19.
//  Copyright © 2019 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import Rustavi2TvShared

extension AppDelegate{
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId = options[.sourceApplication] as! String
        print("opening from app: \(appId)")
        
        if let scheme = url.scheme{
            // widgetapp
            if(scheme.compare(Settings.widgetUrlScheme) == .orderedSame){
                let action = url.host ?? ""
                switch (action) {
                case Settings.widgetAction_LiveVideo:
                    print("open live video")
                    self.openLiveVideo()
                    break;
                    
                case Settings.widgetAction_NewsDetail:
                    let newsId = url.pathComponents.last ?? ""
                    print("open news detail: \(newsId)")
                    self.openNewsDetail(newsId: newsId)
                    break;
                    
                default:
                    break;
                }
            }
        }
        
        return true
    }
    
    func openLiveVideo(){
        HLSVideoPlayerHelper.playVideo(url: Settings.liveStreamUrl, viewCtrl: window?.rootViewController ?? nil)
    }
    
    func openNewsDetail(newsId:String){
        NewsDetailViewController.initialize(newsId: newsId)
    }
}
