//
//  HTMLElem.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/24/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class HTMLElem{
    public var name: String?
    public var attributes:[String: String] = [:]
    public var children: [HTMLElem]?
    public var innerHtmlRange: Range<String.Index>?
    
    private var classNames:Set<String>? = nil
    private var hasClassNames: Bool = false
    
    //var data: String?
    public func innerHTML(originalHtml html:String) -> String{
        if let r = innerHtmlRange{
            if(r.isEmpty){
                return ""
            }
            return String(html[r])
        }
        return ""
    }
    
    ///----------------------------------
    //  Query string structure: -> eg: div>div[1]>span[4]
    // [index] - represents child index.
    // > - represents children/child
    public func lookupChildElement(_ queryString: String) -> HTMLElem?{
        let childSubStrings = queryString.split(separator: ">")
        var currElem:HTMLElem? = self;
        
        for subString in childSubStrings {
            var queryElemName = String(queryString[subString.startIndex..<subString.endIndex])
            var childIndex = 0;
            
            if let startIdx = queryElemName.lastIndex(of: "["){
                if let endIdx = queryElemName.lastIndex(of: "]"){
                    if(startIdx < endIdx){
                        let strIndex = String(queryElemName[queryElemName.index(startIdx, offsetBy: 1)..<endIdx])
                        if let idx = Int(strIndex){
                            childIndex = idx
                        }
                        
                        // Modify element name to remove square brackets.
                        queryElemName = String(queryElemName[queryElemName.startIndex..<startIdx])
                    }
                }
            }
            
            // Veriy children element.
            if((currElem?.children?.count ?? 0) <= childIndex){
                currElem = nil
                break; // Not found.
            }
            
            currElem = currElem?.children?[childIndex]
            
            // Validate element name.
            if(currElem?.name != queryElemName){
                currElem = nil
                break;
            }
        }
        
        return currElem
    }
    
    public static func containsClass(elem: HTMLElem, className:String) -> Bool{
        guard className.count > 0 else {
            return false
        }
        if(!elem.hasClassNames){
            guard let classAttrIdx = elem.attributes.index(forKey: "class") else{
                return false
            }
            
            let arrClassNames = elem.attributes[classAttrIdx].value.split(separator: " ")
            if(arrClassNames.count > 0){
                elem.classNames = Set<String>(arrClassNames.map({ (s) -> String in
                    String(s)
                }))
            }
            elem.hasClassNames = true
        }
        
        return elem.classNames?.contains(className) ?? false
    }
    
    public func lookupChildElementsByClass(_ className:String) -> [HTMLElem]?{
        guard children?.count ?? 0 > 0 else{
            return nil
        }
        
        var result:[HTMLElem]? = nil
        for c in self.children! {
            if(c.children?.count ?? 0 > 0){
                if let resultChild = c.lookupChildElementsByClass(className){
                    if(result == nil){
                        result = []
                    }
                    result?.append(contentsOf: resultChild)
                }
            }
            
            if(HTMLElem.containsClass(elem: c, className: className)){
                if(result == nil){
                    result = []
                }
                result?.append(c)
            }
        }
        
        return result
    }
}
