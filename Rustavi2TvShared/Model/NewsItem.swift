//
//  NewsItem.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/15/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import UIKit

public class NewsItem {
    public init(id: String, title: String, time: Date?, coverImageUrl: String?, videoUrl: String?) {
        self.id = id
        self.title = title
        self.time = time
        self.coverImageUrl = coverImageUrl
        self.videoUrl = videoUrl
    }
    
    public var id: String
    public var time: Date?
    public var title: String
    public var coverImageUrl: String?
    public var coverImage: UIImage?
    public var videoUrl: String?
}
