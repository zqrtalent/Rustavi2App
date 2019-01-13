//
//  ShowItem.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/17/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import CoreData

public class ShowItemMO : NSManagedObject {
    @NSManaged var name:String?
    @NSManaged var desc:String?
    @NSManaged var order:Int16
    @NSManaged var coverImageUrl:String?
    @NSManaged var pageUrl:String?
}
