//
//  NewsTableViewDataSource.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 12/23/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import Rustavi2TvShared

extension NewsTableViewController{
    
    func updateNewsItems(_ newsItems:[NewsItem]!, pageNum:UInt){
        
        //        if let dataCtrl = AppDelegate.dataController{
        //            //dataCtrl.addNewsItems(items)
        //            //dataCtrl.saveContext()
        //            let items = dataCtrl.fetchNewsItems()
        //        }
        
        if(self.newsItems?.count ?? 0 == 0){
            self.newsItems = newsItems
        }
        else{
            var itemsMerged:[NewsItem] = []
            for item in newsItems{
                let found = self.newsItems!.first(where: { (i) -> Bool in return i.id == item.id})
                if let found = found{
                    // Image has been changed.
                    if(found.coverImageUrl != item.coverImageUrl){
                        found.coverImage = nil
                        found.coverImageUrl = item.coverImageUrl
                    }
                    
                    // Title has been changed.
                    if(found.title != item.title){
                        found.title = item.title
                    }
                    
                    // Time has been changed.
                    if(found.time != item.time){
                        found.time = item.time
                    }
                    
                    itemsMerged.append(found)
                }
                else{
                    itemsMerged.append(item)
                }
            }
            self.newsItems = itemsMerged
        }
        
        let tabIndex = 0 // News tab index
        self.tabBarController?.tabBar.items?[tabIndex].badgeValue = String((self.newsItems?.count ?? 0))
    }
}
