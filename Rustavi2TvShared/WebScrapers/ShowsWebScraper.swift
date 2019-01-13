//
//  ShowsWebScrapper.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/14/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class ShowsWebScraper : WebScraper {
    
    public override init() {
        super.init()
    }
    
    var completionBlock: ShowsCompletionHandlerBlock?
    
    public func RetrieveShows(completion: @escaping ([ShowItem]?, String?) -> Void ) {
        receivedData = Data()
        completionBlock = completion
        
        let success = httpGet(Settings.urlShows)
        if(!success){
            completionBlock?(nil, "Failed get http page: \(Settings.urlShows)")
        }
    }
    
    public override func onDataReceiveCompleted(){
        var items: [ShowItem]? = nil
        
        if let data = receivedData {
            /*
             <div class="sh_line">
             
                 <div class="bl">
                     <a href="/ka/shows/kurieri"><div class="ph" style="background-image:url(../shows/3.jpg)"></div></a>
                     <a href="/ka/shows/kurieri" class="lnk link">კურიერი</a>
                     <div class="t">ყოველდღე 21:00</div>
                 </div>
                 <div class="bl">
                     <a href="/ka/shows/kurieri"><div class="ph" style="background-image:url(../shows/3.jpg)"></div></a>
                     <a href="/ka/shows/kurieri" class="lnk link">კურიერი</a>
                     <div class="t">ყოველდღე 21:00</div>
                 </div>
             
             </div>
             */
            
            if let htmlContent:String = String(data: data, encoding: String.Encoding.utf8){
                let range = htmlContent.range(of: "<div class=\"sh_line\">")
                if let r = range{
                    if(r.isEmpty){
                        self.completionBlock?(items, nil)
                        return // No news items have been found!
                    }
                    
                    if let elem = HTMLParserLite.parse(html: htmlContent, startIdx: r.lowerBound){
                        let queryCoverImageElem = "a[0]>div"
                        let queryTitleAndLinkElem = "a[1]"
                        let queryDescriptionElem = "div[2]"
                        
                        items = []
                        if let children = elem.children{
                            for item in children {
                                
                                if(item.children?.count != 3){
                                    continue;
                                }
                                
                                var name:String = ""
                                var coverImageUrl:String? = nil
                                var showPageUrl:String? = nil
                                var description:String? = nil
                                
                                if let coverImageElem = item.lookupChildElement(queryCoverImageElem){
                                    coverImageUrl = HTMLParserUtility.extractBackgroundImageUrl(from: coverImageElem, urlFirstPart: Settings.websiteUrl)
                                }
                                
                                if let titleAndLinkElem = item.lookupChildElement(queryTitleAndLinkElem){
                                    name = titleAndLinkElem.innerHTML(originalHtml: htmlContent)
                                    showPageUrl = "\(Settings.websiteUrl)\(titleAndLinkElem.attributes["href"] ?? "")"
                                }
                                
                                if let descriptionElem = item.lookupChildElement(queryDescriptionElem){
                                    description = descriptionElem.innerHTML(originalHtml: htmlContent)
                                }
                            
                                items?.append(ShowItem(name: name, desc: description, pageUrl: showPageUrl, coverImageUrl: coverImageUrl))
                            }
                        }
                    }
                }
            }
        }
        
        self.completionBlock?(items, nil)
    }
}
