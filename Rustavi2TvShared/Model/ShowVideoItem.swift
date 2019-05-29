//
//  ShowVideoItem.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/23/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class ShowVideoItem : JsonSerializable {
    public init(id:String, title:String, videoPageUrl:String?, coverImageUrl:String?) {
        self.id = id
        self.title = title
        self.videoPageUrl = videoPageUrl
        self.coverImageUrl = coverImageUrl
        
        super.init(json: [:])
    }
    
    required public init(json: [String : Any]) {
        /*
         {
         "id": "string",
         "title": "string",
         "videoPageUrl": "string",
         "coverImageUrl": "string"
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
        else{
            self.title = ""
        }
        
        if let videoPageUrl = json["videoPageUrl"] as? String{
            self.videoPageUrl = videoPageUrl
        }
        
        if let coverImageUrl = json["coverImageUrl"] as? String{
            self.coverImageUrl = coverImageUrl
        }
        
        super.init(json: json)
    }
    
    public var id:String
    public var title:String
    public var videoPageUrl:String?
    public var coverImageUrl:String?
    public var coverImage: UIImage?
}
