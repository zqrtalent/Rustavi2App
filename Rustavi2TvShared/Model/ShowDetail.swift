//
//  ShowDetail.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/23/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class ShowDetail : JsonSerializable {
    init(pageUrl:String?, name:String, desc: String?, mainVideo:ShowVideoItem?, videoItemsBySection:[String:[ShowVideoItem]?]?) {
        self.pageUrl = pageUrl
        self.name = name
        self.desc = desc
        self.mainVideo = mainVideo
        self.videoItemsBySection = videoItemsBySection
        
        super.init(json: [:])
    }
    
    required public init(json: [String : Any]) {
        /*
         "id": "string",
         "desc": "string",
         "mainVideo": {
             "id": "string",
             "title": "string",
             "videoPageUrl": "string",
             "coverImageUrl": "string"
             },
         "sectionVideoItems": [
             {
             "section": "string",
             "videoItems": [
                 {
                 "id": "string",
                 "title": "string",
                 "videoPageUrl": "string",
                 "coverImageUrl": "string"
                 }
             ]
         
         }
         ]
         */
        
        if let id = json["id"] as? String{
            self.id = id
        }
        
        self.name = ""
        
        if let desc = json["desc"] as? String{
            self.desc = desc
        }
        
        if let mainVideo = json["mainVideo"] as? [String: Any]{
            self.mainVideo = ShowVideoItem(json: mainVideo)
        }
        
        if let videoSections = json["sectionVideoItems"] as? [[String:Any]]{
            var videosBySection:[String:[ShowVideoItem]?] = [:]
            for section in videoSections{
                if let name = section["section"] as? String{
                    if let videoItems = section["videoItems"] as? [[String:Any]]{
                        var videos:[ShowVideoItem] = []
                        for videoItem in videoItems{
                            videos.append(ShowVideoItem(json: videoItem))
                        }
                        videosBySection[name] = videos
                    }
                }
            }
            
            self.videoItemsBySection = videosBySection
        }
        
        super.init(json: json)
    }
    
    public var pageUrl:String?
    public var id:String?
    public var name:String
    public var desc: String?
    public var mainVideo:ShowVideoItem?
    public var videoItemsBySection:[String:[ShowVideoItem]?]?
}
