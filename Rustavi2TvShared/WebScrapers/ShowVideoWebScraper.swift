//
//  ShowVideoWebScrapper.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 12/18/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation


public class ShowVideoWebScraper: WebScraper {
    
    public override init() {
        super.init()
    }
    
    var completionBlock: ShowVideoCompletionHandlerBlock?
    var videoPageUrl: String?
    
    private func requestOutOfUrl(_ requestUrl:String) -> URLRequest?{
        var req:URLRequest? = nil
        if let url = URL(string: requestUrl){
            req = URLRequest(url: url)
            req?.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
            req?.setValue("text/html", forHTTPHeaderField: "Accept")
        }
        return req
    }
    
    public func RetrieveShowVideoInfo(_ videoPageUrl: String, completion: @escaping (ShowVideoInfo?, String?) -> Void ) {
        receivedData = Data()
        completionBlock = completion
        self.videoPageUrl = videoPageUrl
        
        let videoInfo = ShowVideoInfo()
        if let req = requestOutOfUrl(videoPageUrl){
            self.downloadAndParse(request: req, parseDataClosure: { (data) -> ShowVideoInfo? in
                videoInfo.videoPageUrl = self.videoPageUrl
                videoInfo.videoFrameUrl = self.parseAndExtractVideoFrameUrl(data: data)
                return videoInfo
            }, callback: {(videoInfo) in
                if let videoFrameUrl = videoInfo?.videoFrameUrl {
                    let scraper = NewsVideoUrlWebScraper()
                    scraper.RetrieveNewsVideoUrl(videoFrameUrl) { (videoUrl, errorDesc) in
                        videoInfo?.videoUrl = videoUrl
                        completion(videoInfo, errorDesc)
                    }
                }
                else{
                    completion(videoInfo, "Couldn't parse/retrieve video frame url")
                }
            })
        }
    }
    
    private func parseAndExtractVideoFrameUrl(data:Data) -> String?{
        var videoFrameUrl: String? = nil
        if let htmlContent:String = String(data: data, encoding: String.Encoding.utf8){
            var searchStart:String.Index = htmlContent.startIndex
            // Read video frame url.
            if let r = htmlContent.range(of: "<div class=\"ph\"", options: .caseInsensitive, range: searchStart..<htmlContent.endIndex, locale: nil) {
                if(!r.isEmpty){
                    searchStart = r.upperBound
                    if let elem = HTMLParserLite.parse(html: htmlContent, startIdx: r.lowerBound){
                        if let children = elem.children{
                            if(children.count > 0 && children[0].name == "iframe"){
                                videoFrameUrl = children[0].attributes["src"]
                                if let r1 = videoFrameUrl?.range(of: "&i="){
                                    videoFrameUrl = String(videoFrameUrl![videoFrameUrl!.startIndex..<r1.lowerBound])
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return videoFrameUrl
    }
}
