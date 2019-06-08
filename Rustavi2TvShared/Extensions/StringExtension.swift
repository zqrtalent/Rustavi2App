//
//  StringExtension.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 12/6/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

extension String {
    public func trimStart(_ trimCharacters:[Character]) -> String{
        guard trimCharacters.count > 0 && !isEmpty else{
            return self
        }
        var idx = self.startIndex
        while idx != self.endIndex && trimCharacters.contains(self[idx]) {
            idx = self.index(idx, offsetBy: 1)
        }
        return idx == self.endIndex ? "" : String(self[idx..<self.endIndex])
    }
    
    public func trimEnd(_ trimCharacters:[Character]) -> String{
        guard trimCharacters.count > 0 && !isEmpty else{
            return self
        }
        
        var idx = self.index(self.endIndex, offsetBy: -1)
        repeat {
            if !trimCharacters.contains(self[idx]){
                break
            }
            else
            if(idx == self.startIndex){
                return ""
            }
            
            idx = self.index(idx, offsetBy: -1)
        } while (true)
        return String(self[self.startIndex..<self.index(idx, offsetBy: 1)])
    }
    
    public func urlEncode() -> String?{
        var cs = CharacterSet.urlPathAllowed
        cs.insert(charactersIn: ":&=?_")
        
        return self.addingPercentEncoding(withAllowedCharacters: cs)
    }
    
    public static func replace(_ replaceStr:String, search:[String], replaceWith:String) -> String{
        if(search.count == 0 || replaceStr.count == 0){
            return replaceStr
        }
        
        var result = replaceStr
        for search in search {
            var range = result.range(of: search)
            while let r = range{
                result.replaceSubrange(r, with: replaceWith)
                range = result.range(of: search)
            }
        }
        
        return result
    }
}
