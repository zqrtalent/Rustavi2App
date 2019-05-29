//
//  JsonEncodable.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 5/26/19.
//  Copyright © 2019 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public protocol Serializable{
    init(json:[String:Any])
}

public class JsonSerializable : Serializable {
    required public init(json:[String:Any]){
    }
    
    open func Deserialize() -> [String:Any]{
        return [:]
    }
}
