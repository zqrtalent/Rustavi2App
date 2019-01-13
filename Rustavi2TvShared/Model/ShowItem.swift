//
//  ShowItem.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/14/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class ShowItem {
    public init(name:String, desc:String?, pageUrl:String?, coverImageUrl:String?) {
        self.name = name
        self.desc = desc
        self.pageUrl = pageUrl
        self.coverImageUrl = coverImageUrl
    }
    
    public var name:String
    public var desc:String?
    public var pageUrl:String?
    public var coverImageUrl:String?
    public var coverImage: UIImage?
}
