//
//  NewsArchiveWebScraper.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 12/22/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class NewsArchiveWebScraper : HttpClient {
    
    public override init() {
        super.init()
    }
    
    var pageNum: UInt = 0
    var completionBlock: NewsArchivePagedCompletionHandlerBlock?
    
    public func RetrieveNewsPaged(_ pageNum:UInt, completion: @escaping (UInt, [NewsItem]?, String?) -> Void ) {
        receivedData = Data()
        completionBlock = completion
        self.pageNum = pageNum
        
        let newsPageUrl = "\(Settings.urlNewsArchivePaged)\(pageNum)"
        let success = GetHtml(newsPageUrl)
        if(!success){
            completionBlock?(pageNum, nil, "Failed get http page: \(newsPageUrl)")
        }
    }
    
    public override func onDataReceiveCompleted(){
        var items: [NewsItem]? = nil
        
        if let data = receivedData {
            /*
             <div class="nw_cont">
             <div class="spacer"></div><div class="date_l en">22-12-2018</div>
             
             <div class="nw_line">
             <div><span class="dt">15:30</span> <a href="/ka/news/121851" class="link">ზვიად გამსახურდიას საქმის გამოძიების ხანდაზმულობა 5 წლით გაგრძელდება  <img src="/img/video.gif"></a></div>
             </div>
             
             <div class="nw_line">
             <div><span class="dt">15:18</span> <a href="/ka/news/121848" class="link">„მინიმუმ შეცდომა და მაქსიმუმ ტრაგედია" - „ქალთა მოძრაობა" პრეზიდენტის საპარლამენტო მდივნად დიმიტრი გაბუნიას დანიშვნას აქციიით აპროტესტებს  <img src="/img/video.gif"></a></div>
             </div>
             
             <div class="spacer"></div><div class="date_l en">22-12-2018</div>
             
             <div class="nw_line">
             <div><span class="dt">15:30</span> <a href="/ka/news/121851" class="link">ზვიად გამსახურდიას საქმის გამოძიების ხანდაზმულობა 5 წლით გაგრძელდება  <img src="/img/video.gif"></a></div>
             </div>
             
             <div class="nw_line">
             <div><span class="dt">15:18</span> <a href="/ka/news/121848" class="link">„მინიმუმ შეცდომა და მაქსიმუმ ტრაგედია" - „ქალთა მოძრაობა" პრეზიდენტის საპარლამენტო მდივნად დიმიტრი გაბუნიას დანიშვნას აქციიით აპროტესტებს  <img src="/img/video.gif"></a></div>
             </div>
             
             </div>
             */
            
            if let htmlContent:String = String(data: data, encoding: String.Encoding.utf8){
                let range = htmlContent.range(of: "<div class=\"nw_cont\">")
                if let r = range{
                    if(r.isEmpty){
                        self.completionBlock?(self.pageNum, items, nil)
                        return // No news items have been found!
                    }
                    
                    if let elem = HTMLParserLite.parse(html: htmlContent, startIdx: r.lowerBound){
                        let queryPageUrlAndTitle = "div[0]>a[1]"
                        let queryTimeElem = "div[0]>span[0]"
                        
                        items = []
                        if let children = elem.children{
                            //var currentDate = Date()
                            var currentDateStr = ""
                            for item in children {
                                
                                if(HTMLElem.containsClass(elem: item, className: "date_l")){
                                    currentDateStr = item.innerHTML(originalHtml: htmlContent)
                                    //currentDate = Date.fromNewsTimeString(currentDateStr, formatString: "dd-MM-yyyy 00:00") ?? Date()
                                    continue
                                }
                                
                                if(HTMLElem.containsClass(elem: item, className: "nw_line")){
                                    var pageUrl = ""
                                    var time = ""
                                    var title:String? = nil
                                    
                                    if let aDiv = item.lookupChildElement(queryPageUrlAndTitle){
                                        pageUrl = aDiv.attributes["href"] ?? ""
                                        
                                        title = aDiv.innerHTML(originalHtml: htmlContent)
                                        if let t = title{
                                            // Remove ending img tag completely
                                            if let r = t.range(of: "<img", options: .caseInsensitive, range: nil, locale: nil){
                                                title = String(t[t.startIndex..<r.lowerBound])
                                            }
                                        }
                                    }
                                    
                                    if let timSpan = item.lookupChildElement(queryTimeElem){
                                        time = "\(currentDateStr) \(timSpan.innerHTML(originalHtml: htmlContent))"
                                    }
                                    
                                    
                                    let newsId = HTMLParserUtility.extractLastParamOfUrl(url: pageUrl)
                                    let coverImageUrl = "\(Settings.urlNewsPhotos)/\(newsId)_video.jpg"
                                    
                                    let tm = Date.fromTimeString(time, formatString: "dd-MM-yyyy HH:mm")
                                    items?.append(NewsItem(id: newsId, title: title ?? "", time: tm, coverImageUrl: coverImageUrl, videoUrl: nil))
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.completionBlock?(self.pageNum, items, nil)
    }
}
