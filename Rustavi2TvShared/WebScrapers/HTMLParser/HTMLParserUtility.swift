//
//  HTMLParserUtility.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/14/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation


public class HTMLParserUtility {
    
    public static func extractBackgroundImageUrl(from elem:HTMLElem, urlFirstPart: String?) -> String?{
        var imageUrl:String?
        
        // background-image:url('/news_photos/116169_cover.jpg')
        let styleBackgroundImage = elem.attributes["style"] ?? ""
        if let startIdx = styleBackgroundImage.lastIndex(of: "("){
            if let endIdx = styleBackgroundImage.lastIndex(of: ")"){
                var urlString = String(styleBackgroundImage[styleBackgroundImage.index(startIdx, offsetBy: 1)..<endIdx])
                if(urlString.hasPrefix("..")){
                    urlString.removeSubrange(urlString.startIndex..<urlString.index(urlString.startIndex, offsetBy: 2))
                }
                imageUrl = "\(urlFirstPart ?? "")\(urlString)"
            }
        }
        
        return imageUrl
    }
    
    public static func extractLastParamOfUrl(url:String) -> String {
        var lastParam = ""
        if let startIdIdx = url.lastIndex(of: "/"){
            lastParam = String(url[url.index(startIdIdx, offsetBy: 1)..<(url.lastIndex(of: "?") ?? url.endIndex)])
        }
        return lastParam
    }
    
    public static func getRidOfTheHTMLComments(_ html:String) -> String{
        var startIdx = html.startIndex
        let commentStart = "<!--"
        let commentEnd = "-->"
        
        var comments:[Range<String.Index>] = []
        while true {
            if let startCommentRange = html.range(of: commentStart, options: .caseInsensitive, range: startIdx..<html.endIndex, locale: nil){
                if(!startCommentRange.isEmpty){
                    startIdx = startCommentRange.upperBound
                    if let endCommentRange = html.range(of: commentEnd, options: .caseInsensitive, range: startIdx..<html.endIndex, locale: nil){
                        comments.append(startCommentRange.lowerBound..<endCommentRange.upperBound)
                        startIdx = endCommentRange.upperBound
                        continue; // Continue searching for HTML comments.
                    }
                }
            }
            break;
        }
        
        if(comments.count == 0){
            return html
        }
        
        var resultHtml = ""
        var startIndex = html.startIndex
        for (index,r) in comments.enumerated(){
            resultHtml += String(html[startIndex..<r.lowerBound])
            if(index == comments.count - 1){
                resultHtml += String(html[r.upperBound..<html.endIndex])
            }
            else{
                startIndex = r.upperBound
            }
        }
        
        return resultHtml
    }
    
}
