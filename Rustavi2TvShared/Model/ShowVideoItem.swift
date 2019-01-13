//
//  ShowVideoItem.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/23/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class ShowVideoItem {
    public init(id:String, title:String, videoPageUrl:String?, coverImageUrl:String?) {
        self.id = id
        self.title = title
        self.videoPageUrl = videoPageUrl
        self.coverImageUrl = coverImageUrl
    }
    
    public var id:String
    public var title:String
    public var videoPageUrl:String?
    public var coverImageUrl:String?
    public var coverImage: UIImage?
}
