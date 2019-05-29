//
//  NewsDetail.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/26/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import UIKit

public class NewsDetail : JsonSerializable {
    
    public init(id:String, coverImageUrl: String?, storyDetail: String?, videoFrameUrl: String?, title:String? = nil, time:Date? = nil) {
        self.id = id
        self.coverImageUrl = coverImageUrl
        self.storyDetail = storyDetail
        self.videoFrameUrl = videoFrameUrl
        self.title = title
        self.time = time
        
        super.init(json: [:])
    }
    
    required public init(json: [String : Any]) {
        
        /*
         {
         "id": "string",
         "time": "2019-05-26T20:13:53.672Z",
         "title": "string",
         "coverImageUrl": "string",
         "storyDetail": "string",
         "videoUrl": "string"
         }
         */
        
        if let id = json["id"] as? String{
            self.id = id
        }
        else{
            self.id = ""
        }
        
        if let title = json["title"] as? String{
            self.title = title
        }
        
        if let time = json["time"] as? String{
            self.time = Date.fromTimeString(time, formatString: nil)
        }
        
        if let coverImageUrl = json["coverImageUrl"] as? String{
            self.coverImageUrl = coverImageUrl
        }
        
        if let storyDetail = json["storyDetail"] as? String{
            self.storyDetail = storyDetail
        }
        
        if let videoUrl = json["videoUrl"] as? String{
            self.videoUrl = videoUrl
        }
        
        super.init(json: json)
    }
    
    public var id: String
    public var title: String?
    public var time: Date?
    public var coverImageUrl: String?
    public var coverImage: UIImage?
    public var storyDetail: String?
    public var videoFrameUrl: String?
    public var videoUrl: String?
}
