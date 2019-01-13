//
//  NewsVideoUrlWebScrapper.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/27/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

/*
 title: '',
 clip: {
 sources: [{ type: "application/x-mpegurl", src: "http://vodstream.rustavi2.ge/vodr2live/_definst_/news portal/2018/oqtomberi_/27/6 baqraze axalfazrdebtan.mp4/playlist.m3u8" }],
 autoplay: false
 }
 */

public class NewsVideoUrlWebScraper: WebScraper {
    
    public override init() {
        super.init()
    }
    
    var completionBlock: NewsVideoUrlCompletionHandlerBlock?

    public func RetrieveNewsVideoUrl(_ videoFrameUrl: String, completion: @escaping (String?, String?) -> Void ) {
        receivedData = Data()
        completionBlock = completion
        let videoFrameUrlEncoded = videoFrameUrl.replacingOccurrences(of: " ", with: "%20")
        let success = httpGet(videoFrameUrlEncoded)
        if(!success){
            completionBlock?(nil, "Failed get http page: \(videoFrameUrlEncoded)")
        }
    }

    public override func onDataReceiveCompleted(){
        var videoUrl: String? = nil

        if let data = receivedData {
            if let htmlContent:String = String(data: data, encoding: String.Encoding.utf8){
                // Read news post video url.
                if let r = htmlContent.range(of: "playlist.m3u8"){
                    if(!r.isEmpty){
                        if let startRange = htmlContent.range(of: "http", options: .backwards, range: htmlContent.startIndex..<r.lowerBound){
                            videoUrl = String(htmlContent[startRange.lowerBound..<r.upperBound])
                        }
                    }
                }
            }
        }
        
        self.completionBlock?(videoUrl, nil)
    }
}
