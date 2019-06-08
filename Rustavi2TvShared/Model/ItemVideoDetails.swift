//
//  NewsItem.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/15/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import UIKit

public class ItemVideoDetails : JsonSerializable {
    public init(id: String, videoTypeId: Int, videoUrl: String) {
        self.id = id
        self.videoUrl = videoUrl
        self.videoTypeId = videoTypeId
        
        super.init(json: [:])
    }
    
    required public init(json: [String : Any]) {
        if let id = json["id"] as? String{
            self.id = id
        }
        else{
            self.id = ""
        }
        
        if let videoTypeId = json["videoTypeId"] as? Int{
            self.videoTypeId = videoTypeId
        }
        else{
            self.videoTypeId = -1
        }
        
        if let videoUrl = json["videoUrl"] as? String{
            self.videoUrl = videoUrl
        }
        
        super.init(json: json)
    }
    
    public var id: String
    public var videoUrl: String?
    public var videoTypeId: Int
}
