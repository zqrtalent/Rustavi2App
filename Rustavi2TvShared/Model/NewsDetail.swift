//
//  NewsDetail.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/26/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import UIKit

public class NewsDetail {
    public init(id:String, coverImageUrl: String?, storyDetail: String?, videoFrameUrl: String?, title:String? = nil, time:Date? = nil) {
        self.id = id
        self.coverImageUrl = coverImageUrl
        self.storyDetail = storyDetail
        self.videoFrameUrl = videoFrameUrl
        self.title = title
        self.time = time
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
