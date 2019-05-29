//
//  ShowItem.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/14/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class ShowItem : JsonSerializable {
    public init(name:String, desc:String?, pageUrl:String?, coverImageUrl:String?) {
        self.name = name
        self.desc = desc
        self.pageUrl = pageUrl
        self.coverImageUrl = coverImageUrl
        
        super.init(json: [:])
    }
    
    required public init(json: [String : Any]) {
        
        /*
         {
         "id": "string",
         "name": "string",
         "desc": "string",
         "pageUrl": "string",
         "coverImageUrl": "string"
         }
         */
        
        if let id = json["id"] as? String{
            self.id = id
        }
        
        if let name = json["name"] as? String{
            self.name = name
        }
        else{
            self.name = ""
        }
        
        if let desc = json["desc"] as? String{
            self.desc = desc
        }
        
        if let pageUrl = json["pageUrl"] as? String{
            self.pageUrl = pageUrl
        }
        
        if let coverImageUrl = json["coverImageUrl"] as? String{
            self.coverImageUrl = coverImageUrl
        }
        
        super.init(json: json)
    }
    
    public var id:String?
    public var name:String
    public var desc:String?
    public var pageUrl:String?
    public var coverImageUrl:String?
    public var coverImage: UIImage?
}
