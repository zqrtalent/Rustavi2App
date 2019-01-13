//
//  ShowDetail.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/23/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class ShowDetail {
    init(pageUrl:String?, name:String, desc: String?, mainVideo:ShowVideoItem?, videoItemsBySection:[String:[ShowVideoItem]?]?) {
        self.pageUrl = pageUrl
        self.name = name
        self.desc = desc
        self.mainVideo = mainVideo
        self.videoItemsBySection = videoItemsBySection
    }
    
    public var pageUrl:String?
    public var name:String
    public var desc: String?
    public var mainVideo:ShowVideoItem?
    public var videoItemsBySection:[String:[ShowVideoItem]?]?
}
