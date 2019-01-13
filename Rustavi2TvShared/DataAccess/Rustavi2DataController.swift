//
//  Rustavi2DataContext.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/25/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import CoreData
import os

public class Rustavi2DataController : DataAccessController {
    
    public func addNewsItems(_ items:[NewsItem]){
        for item in items{
            let entityObj = NSEntityDescription.insertNewObject(forEntityName: "NewsItemEntity", into: self.managedObjectContext) as! NewsItemMO
            entityObj.id = item.id
            entityObj.time = item.time
            entityObj.title = item.title
            entityObj.videoUrl = item.videoUrl
            entityObj.coverImageUrl = item.coverImageUrl
        }
    }
    
    public func fetchNewsItems() -> [NewsItem]?{
        var resultItems:[NewsItem]? = nil
        let fetchReq = NSFetchRequest<NewsItemMO>(entityName: "NewsItemEntity")
        //fetchReq.fetchLimit = 10
        
        do{
            let fetchedNewsItems = try managedObjectContext.fetch(fetchReq)
            resultItems = []
            
            for entityItem in fetchedNewsItems{
                let item = NewsItem(id: entityItem.id ?? "", title: entityItem.title ?? "", time: nil, coverImageUrl: entityItem.coverImageUrl, videoUrl: entityItem.videoUrl)
                resultItems?.append(item)
            }
        }
        catch{
            os_log("Failed to fetch NewsItem!")
        }
        return resultItems
    }
    
    public func addNewsDetailItems(_ items:[NewsDetail]){
        for item in items{
            let entityObj = NSEntityDescription.insertNewObject(forEntityName: "NewsDetailEntity", into: self.managedObjectContext) as! NewsDetailMO
            entityObj.id = item.id
            entityObj.title = item.title
            entityObj.time = item.time
            entityObj.videoUrl = item.videoUrl
            entityObj.coverImageUrl = item.coverImageUrl
            entityObj.storyDetail = item.storyDetail
            entityObj.videoFrameUrl = item.videoFrameUrl
        }
    }
    
    public func fetchNewsDetailItem(_ newsId:String) -> NewsDetail?{
        var resultItem:NewsDetail? = nil
        let fetchReq = NSFetchRequest<NewsDetailMO>(entityName: "NewsDetailEntity")
        fetchReq.predicate = NSPredicate(format: "id == %@", newsId)
        fetchReq.fetchLimit = 1
        
        do{
            let fetchedNewsDetail = try managedObjectContext.fetch(fetchReq)
            if let entityObj = fetchedNewsDetail.first{
                let item = NewsDetail(id: newsId, coverImageUrl: entityObj.coverImageUrl, storyDetail: entityObj.storyDetail, videoFrameUrl: entityObj.videoFrameUrl, title: entityObj.title, time: entityObj.time)
                item.videoUrl = entityObj.videoUrl
                resultItem = item
            }
        }
        catch{
            os_log("Failed to fetch NewsDetail!")
        }
        return resultItem
    }
    
    public func addShowItems(_ items:[ShowItem]){
        for item in items{
            let entityObj = NSEntityDescription.insertNewObject(forEntityName: "ShowItemEntity", into: self.managedObjectContext) as! ShowItemMO
            entityObj.name = item.name
            entityObj.desc = item.desc
            entityObj.coverImageUrl = item.coverImageUrl
            entityObj.order = 0
            entityObj.pageUrl = item.pageUrl
        }
    }
    
    public func saveContext(){
        let context = self.managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
