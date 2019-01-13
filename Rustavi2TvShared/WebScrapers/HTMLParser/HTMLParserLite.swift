//
//  HTMLParserLite.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/17/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class HTMLParserLite {
    
    public static func parse(html: String, startIdx: String.Index) -> HTMLElem? {
        return parseElement(html: html, startIdx: startIdx, parentElem: nil);
    }
    
    private static func parseElement(html: String, startIdx: String.Index, parentElem: HTMLElem? = nil) -> HTMLElem? {
        if(html.isEmpty){
            return nil
        }
        var parent:HTMLElem? = nil
        let elemData = readElement(html: html, currIndex: startIdx, parent: &parent)
        return elemData?.elem
    }
    
    struct SubStringRange {
        init(start: String.Index, end: String.Index) {
            startIndex = start
            endIndex = end
        }
        
        public var startIndex: String.Index
        public var endIndex: String.Index
    }
    
    struct SubStringHtmlAttributes {
        init(start: String.Index, end: String.Index, attr: [String: String]?) {
            startIndex = start
            endIndex = end
            self.attributes = attr
        }
        
        public var startIndex: String.Index
        public var endIndex: String.Index
        public var attributes: [String: String]?
    }
    
    struct SubStringHtmlAttribute {
        init(start: String.Index, end: String.Index, name: String, value: String) {
            startIndex = start
            endIndex = end
            self.name = name
            self.value = value
        }
        
        public var startIndex: String.Index
        public var endIndex: String.Index
        public var name: String
        public var value: String
    }
    
    private static func skipWhitespace(html: String, currIndex: String.Index, inversion: Bool) -> String.Index {
        var newCurrIndex = currIndex
        if(!inversion)
        {
            while(html.endIndex != newCurrIndex &&
                (html[newCurrIndex] == " " ||
                    html[newCurrIndex] == "\t" ||
                    html[newCurrIndex] == "\r" ||
                    html[newCurrIndex] == "\n") )
            {
                newCurrIndex = html.index(newCurrIndex, offsetBy: 1)
            }
        }
        else
        {
            while(html.endIndex != newCurrIndex &&
                !(html[newCurrIndex] == " " ||
                    html[newCurrIndex] == "\t" ||
                    html[newCurrIndex] == "\r" ||
                    html[newCurrIndex] == "\n" ||
                    html[newCurrIndex] == "\\" ||
                    html[newCurrIndex] == ">"))
            {
                newCurrIndex = html.index(newCurrIndex, offsetBy: 1)
            }
        }
        
        return newCurrIndex
    }
    
    private static func readAttributes(html: String, currIndex: String.Index) -> SubStringHtmlAttributes? {
        if(html.endIndex == currIndex){
            return nil
        }
        
        var result:SubStringHtmlAttributes? = nil
        if var endOfElementAttributes = findCharacter(html: html, currIndex: currIndex, character: ">"){
            if(html[html.index(endOfElementAttributes, offsetBy: -1)] == "/"){
                endOfElementAttributes = html.index(endOfElementAttributes, offsetBy: -1)
            }
            
            var attributes:[String:String] = [:]
            var idx = currIndex
            
            while let attr = readAttribute(html:html, currIndex: idx, endIndex: endOfElementAttributes ){
                // Copy attribute
                attributes[attr.name] = attr.value
                // Skip double quotte symbol (")
                idx = html.index(attr.endIndex, offsetBy:1)
            }
            
            result = SubStringHtmlAttributes(start: currIndex, end: endOfElementAttributes, attr: (attributes.count > 0 ? attributes : nil))
        }
        return result
    }
    
    private static func readAttribute(html: String, currIndex: String.Index, endIndex: String.Index) -> SubStringHtmlAttribute? {
        let startAttributeIdx = skipWhitespace(html: html, currIndex: currIndex, inversion: false)
        if(startAttributeIdx >= endIndex){
            return nil
        }
        
        if let assignIdx = findCharacter(html: html, currIndex: html.index(startAttributeIdx, offsetBy: 1), character: "="){
            if let startDblQuoute = findCharacter(html: html, currIndex: html.index(assignIdx, offsetBy: 1), character: "\""){
                if let endDblQuoute = findCharacter(html: html, currIndex: html.index(startDblQuoute, offsetBy: 1), character: "\""){
                    return SubStringHtmlAttribute(
                        start: startAttributeIdx,
                        end: endDblQuoute,
                        name: String(html[startAttributeIdx..<assignIdx]),
                        value: String(html[html.index(startDblQuoute, offsetBy:+1)..<endDblQuoute]))
                }
            }
        }
        return nil
    }
    
    private static func findWord(html: String, currIndex: String.Index) -> SubStringRange?{
        let startIdx = skipWhitespace(html: html, currIndex: currIndex, inversion: false)
        let endIdx = skipWhitespace(html: html, currIndex: startIdx, inversion: true)
        
        if(startIdx != endIdx){
            return SubStringRange(start: startIdx, end: endIdx)
        }
        return nil
    }
    
    private static func findWordsSequence(html: String, currIndex: String.Index, sequence:[String]) -> String.Index?{
        if(sequence.count == 0){
            return nil
        }
        
        var idx = currIndex
        for item in sequence {
            idx = skipWhitespace(html: html, currIndex: idx, inversion: false)
            for c in item {
                if( idx == html.endIndex || html[idx] != c){
                    return nil
                }
                idx = html.index(idx, offsetBy: 1)
            }
        }
        
        return idx
    }
    
    private static func findCharacter(html: String, currIndex: String.Index, character: Character) -> String.Index?{
        var newCurrIndex = currIndex
        while(html.endIndex != newCurrIndex && html[newCurrIndex] != character){
            newCurrIndex = html.index(newCurrIndex, offsetBy: 1)
        }
        return html.endIndex != newCurrIndex ? newCurrIndex : nil
    }
    
    private static func readElement(html: String, currIndex: String.Index, parent: inout HTMLElem?) -> (elem: HTMLElem, startIndex: String.Index, endIndex: String.Index, parentElement:Bool)? {
        var elem: HTMLElem? = nil
        var endIndex: String.Index = currIndex
        var startIndex: String.Index = currIndex
        
        if let openTagIndex = findCharacter(html: html, currIndex:currIndex, character:"<"){
            // Check for parent element ending: </[parent?.name]>
            if let parentElemName = parent?.name {
                if let endingIdx = findWordsSequence(html: html, currIndex: html.index(openTagIndex, offsetBy: 1), sequence: ["/",parentElemName,">"]){
                    return (parent!, openTagIndex, endingIdx, true) // Close tag of parent element.
                }
            }
            
            startIndex = openTagIndex
            
            if let elemRange = findWord(html: html, currIndex: html.index(openTagIndex, offsetBy: 1)){
                //let word = String(html[elemRange.startIndex..<elemRange.endIndex])
                if let attributesResult = readAttributes(html: html, currIndex: elemRange.endIndex){
                    elem = HTMLElem()
                    // Copy element name.
                    elem?.name = String(html[elemRange.startIndex..<elemRange.endIndex])
                    
                    if let attributes = attributesResult.attributes{
                        elem?.attributes = attributes
                    }
                    
                    // Add new element as child to parent.
                    if(parent != nil){
                        if(parent?.children == nil){
                            parent?.children = [elem!]
                        }
                        else{
                            parent?.children?.append(elem!)
                        }
                    }
                    
                    // Parse child HTML elements.
                    if(html[attributesResult.endIndex] == ">"){
                        // Self closing tags: img, br etc.
                        if(elem?.name?.lowercased() == "img" || elem?.name?.lowercased() == "br"){
                            endIndex = attributesResult.endIndex
                            return (elem!, startIndex, endIndex, false)
                        }
                        
                        endIndex = html.index(attributesResult.endIndex, offsetBy: 1)
                        let innerStartIndex = endIndex
                        var innerEndIndex = endIndex
                        while let childResult = readElement(html: html, currIndex: endIndex, parent: &elem){
                            endIndex = childResult.endIndex
                            // Parent closing tag
                            if(childResult.parentElement){
                                //innerEndIndex = html.index(childResult.startIndex, offsetBy: -1)
                                innerEndIndex = childResult.startIndex
                                break; // No more child
                            }
                        }
                        
                        // >ვიქტორ ჯაფარიძე არის ხელისუფლების მესენჯერი - ელისო კილაძე
                        // Copy element data
                        if(innerStartIndex < innerEndIndex){
                            //let elementData = String(html[innerStartIndex..<innerEndIndex])
                            elem?.innerHtmlRange = innerStartIndex..<innerEndIndex
                        }
                    }
                    else
                    if(html[attributesResult.endIndex] == "/"){ // No inner html available.
                        if let sequenceEndIndex = findWordsSequence(html: html, currIndex: attributesResult.endIndex, sequence: ["/", ">"]){
                            endIndex = sequenceEndIndex
                        }
                        else{
                            assert(false) // Unexpected
                        }
                    }
                    else{
                        assert(false) // Unexpected
                    }
                }
            }
        }
        
        return elem != nil ? (elem!, startIndex, endIndex, false) : nil
    }
}
