//
//  NewsDetailWebScrapper.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/26/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class NewsDetailWebScraper: HttpClient {
    
    public override init() {
        super.init()
    }
    
    var completionBlock: NewsDetailCompletionHandlerBlock?
    var _newsId: String?
    
    public func RetrieveNewsDetail(_ newsId: String, completion: @escaping (NewsDetail?, String?) -> Void ) {
        receivedData = Data()
        completionBlock = completion
        _newsId = newsId
        
        let httpUrl = "\(Settings.urlNewsDetail)/\(newsId)"
        let success = GetHtml(httpUrl)
        if(!success){
            completionBlock?(nil, "Failed get http page: \(httpUrl)")
        }
    }
    
    public override func onDataReceiveCompleted(){
        var newsDetail: NewsDetail? = nil
        
        if let data = receivedData {
            if let htmlContent:String = String(data: data, encoding: String.Encoding.utf8){
                var searchStart:String.Index = htmlContent.startIndex
                
                /*
                 <div itemprop="name" class="title">მთავრობა შავი ჯიპებით - ხელისუფლებამ 2013 წლიდან დღემდე მანქანებში 200 მილიონი დახარჯა</div>
                 */
                var title:String? = nil
                if let r = htmlContent.range(of: "<div itemprop=\"name\"", options: .caseInsensitive, range: searchStart..<htmlContent.endIndex, locale: nil) {
                    if(!r.isEmpty){
                        searchStart = r.upperBound
                        if let elem = HTMLParserLite.parse(html: htmlContent, startIdx: r.lowerBound){
                            title = elem.innerHTML(originalHtml: htmlContent)
                        }
                    }
                }
                
                /*
                 <div itemprop="datePublished" content="2018-11-24T22:52" class="dt red">24-11-2018 22:52
                 <div class="news_soc">
                 <div class="soc_bl" style="min-width:70px;">
                 <img src="/img/soc1.png">
                 <div class="com black en" id="vis">679</div>
                 </div>
                 <a href="http://www.facebook.com/dialog/feed?app_id=291173801075631&amp;redirect_uri=http%3A%2F%2Frustavi2.ge%2Fka%2Fnews%2F119552&amp;link=http%3A%2F%2Frustavi2.ge%2Fka%2Fnews%2F119552" class="soc_bl face hvr-grow"></a>
                 <a href="https://twitter.com/intent/tweet?text=მთავრობა შავი ჯიპებით - ხელისუფლებამ 2013 წლიდან დღემდე მანქანებში 200 მილიონი დახარჯა&amp;url=http%3A%2F%2Frustavi2.ge%2Fka%2Fnews%2F119552" class="soc_bl twit hvr-grow"></a>
                 
                 <a href="https://plus.google.com/share?url=http%3A%2F%2Frustavi2.ge%2Fka%2Fnews%2F119552" class="soc_bl gogl hvr-grow"></a>
                 </div>
                 </div>
                 */
                var time: String? = nil
                if let r = htmlContent.range(of: "<div itemprop=\"datePublished\"", options: .caseInsensitive, range: searchStart..<htmlContent.endIndex, locale: nil) {
                    if(!r.isEmpty){
                        searchStart = r.upperBound
                        if let elem = HTMLParserLite.parse(html: htmlContent, startIdx: r.lowerBound){
                            if let tm = elem.attributes["content"]{
                                if let rT = tm.range(of: "T"){
                                    time = tm.replacingCharacters(in: rT, with: " ")
                                }
                            }
                        }
                    }
                }
                
                var videoFrameUrl: String? = nil
                // Read news post video frame url.
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
            
                // Read news post detail.
                if let r = htmlContent.range(of: "<span itemprop=\"articleBody\">", options: .caseInsensitive, range: searchStart..<htmlContent.endIndex, locale: nil) {
                    if(r.isEmpty){
                        self.completionBlock?(newsDetail, nil)
                        return // No news detail have been found!
                    }
                    
                    searchStart = r.upperBound
                    if let elem = HTMLParserLite.parse(html: htmlContent, startIdx: r.lowerBound){
                        let storyDetail = elem.innerHTML(originalHtml: htmlContent)
                        
                        newsDetail = NewsDetail(id: _newsId ?? "", coverImageUrl: "\(Settings.urlNewsPhotos)/\(_newsId ?? "")_video.jpg", storyDetail: storyDetail, videoFrameUrl: videoFrameUrl, title: title, time: Date.fromTimeString(time, formatString: nil))
                    }
                }
            }
        }
        
        self.completionBlock?(newsDetail, nil)
    }
}
