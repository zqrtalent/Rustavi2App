//
//  NewsItemEntity.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/17/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import CoreData

public class NewsItemMO : NSManagedObject {
    
    @NSManaged var id:String?
    @NSManaged var time:Date?
    @NSManaged var title:String?
    @NSManaged var coverImageUrl:String?
    @NSManaged var videoUrl:String?
}
