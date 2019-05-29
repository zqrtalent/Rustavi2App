//
//  NewsWebScrapper.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/15/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class NewsWebScraper : HttpClient {
    
    public override init() {
        super.init()
    }
    
    var completionBlock: NewsCompletionHandlerBlock?
    
    public func RetrieveNews( completion: @escaping ([NewsItem]?, String?) -> Void ) {
        receivedData = Data()
        completionBlock = completion
        
        let success = GetHtml(Settings.urlNews)
        if(!success){
            completionBlock?(nil, "Failed get http page: \(Settings.urlNews)")
        }
    }
    
    public override func onDataReceiveCompleted(){
        var items: [NewsItem]? = nil
        
        if let data = receivedData {
            /*
             <a href="/ka/news/116169" class="news_item">
             <div class="img_box">
             <div class="news_photo" style="background-image:url(/news_photos/116169_cover.jpg)"></div>
             </div>
             <div class="news_info">
             <span class="red rioni date">22:57</span>
             <div class="grey nino ">ვიქტორ ჯაფარიძე არის ხელისუფლების მესენჯერი - ელისო კილაძე <img src="/img/video.gif"> </div>
             </div>
             <div style="clear:both"></div>
             </a>
             */
            
            if let htmlContent:String = String(data: data, encoding: String.Encoding.utf8){
                let range = htmlContent.range(of: "<div class=\"all_news_block\">")
                if let r = range{
                    if(r.isEmpty){
                        self.completionBlock?(items, nil)
                        return // No news items have been found!
                    }
                    
                    if let elem = HTMLParserLite.parse(html: htmlContent, startIdx: r.lowerBound){
                        let queryCoverImageElem = "div[0]>div"
                        let queryTimeElem = "div[1]>span[0]"
                        let queryTitleElem = "div[1]>div[1]"
                        
                        items = []
                        if let children = elem.children{
                            for item in children {
                                let newsPageUrl: String = item.attributes["href"] ?? ""
                                let newsId = HTMLParserUtility.extractLastParamOfUrl(url: newsPageUrl)
                                
                                var coverImageUrl: String?
                                var title: String?
                                var time: String?
                                
                                if let coverImageDiv = item.lookupChildElement(queryCoverImageElem){
                                    coverImageUrl = HTMLParserUtility.extractBackgroundImageUrl(from: coverImageDiv, urlFirstPart: Settings.websiteUrl)
                                }
                                
                                if let timeDiv = item.lookupChildElement(queryTimeElem){
                                    time = timeDiv.innerHTML(originalHtml: htmlContent)
                                }
                                
                                if let titleDiv = item.lookupChildElement(queryTitleElem){
                                    title = titleDiv.innerHTML(originalHtml: htmlContent)
                                    
                                    if let t = title{
                                        // Remove ending img tag completely
                                        if let r = t.range(of: "<img", options: .caseInsensitive, range: nil, locale: nil){
                                            title = String(t[t.startIndex..<r.lowerBound])
                                        }
                                    }
                                }
                                
                                let tm = Date.fromTimeString(time, formatString: nil)
                                items?.append(NewsItem(id: newsId, title: title ?? "", time: tm, coverImageUrl: coverImageUrl, videoUrl: nil))
                            }
                        }
                    }
                }
            }
        }
        
        self.completionBlock?(items, nil)
    }
}
