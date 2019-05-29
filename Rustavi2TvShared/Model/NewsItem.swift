//
//  NewsItem.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/15/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import UIKit

public class NewsItem : JsonSerializable {
    public init(id: String, title: String, time: Date?, coverImageUrl: String?, videoUrl: String?) {
        self.id = id
        self.title = title
        self.time = time
        self.coverImageUrl = coverImageUrl
        self.videoUrl = videoUrl
        
        super.init(json: [:])
    }
    
    required public init(json: [String : Any]) {
        if let id = json["id"] as? String{
            self.id = id
        }
        else{
            self.id = ""
        }
        
        if let time = json["time"] as? String{
            self.time = Date.fromTimeString(time, formatString: "yyyy-MM-dd'T'HH:mm:ss")
        }
        
        if let title = json["title"] as? String{
            self.title = title
        }
        else{
            self.title = ""
        }
        
        if let coverImageUrl = json["coverImageUrl"] as? String{
            self.coverImageUrl = coverImageUrl
        }
        
        super.init(json: json)
    }
    
    public var id: String
    public var time: Date?
    public var title: String
    public var coverImageUrl: String?
    public var coverImage: UIImage?
    public var videoUrl: String?
}
