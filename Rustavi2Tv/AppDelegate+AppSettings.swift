//
//  AppDelegate+AppSettings.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 1/27/19.
//  Copyright © 2019 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import Rustavi2TvShared

extension AppDelegate{
    
    func restoreAppState(){
        restoreTabBarState()
    }
    
    func saveAppState(){
        saveTabBarState()
        
        AppSettings.shared.save()
    }
    
    private func restoreTabBarState(){
        var tabIndex = 0
        let tabBarCtrl = self.window?.rootViewController as! UITabBarController
        
        switch AppSettings.shared.currentTabItem {
        case .newsItems:
            tabIndex = 0
        case .tvShows:
            tabIndex = 1
        }
        
        tabBarCtrl.selectedIndex = tabIndex
    }
    
    private func saveTabBarState(){
        let tabBarCtrl = self.window?.rootViewController as! UITabBarController
        switch tabBarCtrl.selectedIndex {
        case 0:
            AppSettings.shared.currentTabItem = .newsItems
        case 1:
            AppSettings.shared.currentTabItem = .tvShows
        default:
            AppSettings.shared.currentTabItem = .newsItems
        }
    }
}
