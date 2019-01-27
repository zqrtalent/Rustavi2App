//
//  AppSettings.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 1/27/19.
//  Copyright © 2019 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public enum TabBarItemType : Int {
    case newsItems = 1
    case tvShows = 2
}

public class AppSettings {

    public static var shared = AppSettings()
    
    private init() {
        self.userDefaults = UserDefaults(suiteName: Settings.appGroupId)
        self.load()
    }
    
    public var currentTabItem: TabBarItemType = .newsItems
    
    private var userDefaults: UserDefaults? = nil
    
    public func load(){
        guard let defaults = self.userDefaults else{
            return
        }
        
        self.currentTabItem = TabBarItemType(rawValue: defaults.integer(forKey: "currentTabItem")) ?? .newsItems
    }
    
    public func save() -> Void{
        self.userDefaults?.set(self.currentTabItem.rawValue, forKey: "currentTabItem")
    }
}
