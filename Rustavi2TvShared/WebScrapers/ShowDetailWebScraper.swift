//
//  ShowDetailWebScrapper.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/23/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class ShowDetailWebScraper : WebScraper {
    
    public override init() {
        super.init()
    }
    
    var pageUrl:String = ""
    var showName:String = ""
    var completionBlock: ShowDetailCompletionHandlerBlock?
    
    public func RetrieveShowDetails(showName: String, showPageUrl:String, completion: @escaping (ShowDetail?, String?) -> Void ) {
        receivedData = Data()
        completionBlock = completion
        
        var cs = CharacterSet.urlPathAllowed
        cs.insert(charactersIn: ":&=?_")
        
        if let encodedUrlString = showPageUrl.addingPercentEncoding(withAllowedCharacters: cs){
            self.pageUrl = encodedUrlString
            self.showName = showName
            
            let success = httpGet(encodedUrlString)
            if(!success){
                completionBlock?(nil, "Failed get http page: \(encodedUrlString)")
            }
        }
    }
    
    public override func onDataReceiveCompleted(){
        guard self.completionBlock != nil else {
            return
        }
        
        if let data = receivedData {
            if let htmlContent:String = String(data: data, encoding: String.Encoding.utf8){
                extractShowDetail(HTMLParserUtility.getRidOfTheHTMLComments(htmlContent), pageUrl: self.pageUrl, completion: {(detail) -> Void in self.completionBlock!(detail, nil) })
            }
        }
    }
    
    func extractShowDetail(_ html:String, pageUrl:String, completion: @escaping (ShowDetail?) -> Void) {
        var showDesc:String? = nil
        var mainVideoTitle:String? = nil
        var mainVideoCoverImageUrl:String? = nil
        var mainVideoPageUrl:String? = nil
        
 /*
 <div class="vd">
 <div class="l">
 <div class="pl">
 <div class="ph" style="background-image:url(/shows_videos/38191.jpg)" id="plr">
 <!--<a onClick="show_vplayer('#plr','38191')"></a>-->
 <a href="/ka/video/38191?v=2" class="link"></a>
 </div>
 <div class="txt rioni">შაბათის კურიერი - 1 დეკემბერი, 2018</div>
 </div>
 </div>
 <div class="r">
 <div class="r_hed black nino">&nbsp; გადაცემის შესახებ</div>
 <div class="r_txt rioni black"><p><span>შაბათის კურიერი –ნოდარ მელაძის გადაცემა კვირისა და დღის მოვლენების საავტორო შეფასებით. არა მარტო მშრალი ინფორმაცია, არამედ ფაქტების ღრმა ანალიზი სტუმრებთან ერთად. კვირის მთავარი თემების, მთავარი მოქმედი გმირები, შაბათის კურიერის ეთერში აჯამებენ მთავარ მოვლენებს.</span></p>
 <p><span data-mce-mark="1">ინფორმაციას მაყურებელი იღებს უახლესი სატელევიზიო ტექნოლოგიების გამოყენებით როგორიცაა ვირტუალური სტუდია. შაბათის კურიერის ჟურნალისტები კი მოვლენების ეპიცენტრიდან პირდაპირ ეთერში მაყურელებს ყველა აქტუალური თემის შესახებ უამბობენ.</span></p></div>
 <!--
 <div class="fb-like-box" data-href="" data-width="287" data-height="340" data-colorscheme="light" data-show-faces="true" data-header="true" data-stream="false" data-show-border="true"></div>-->
 </div>
 <div style="clear:both"></div>
 </div>
        */
        
        let range = html.range(of: "<div class=\"vd\">")
        if let r = range{
            if(r.isEmpty){
                completion(nil)
                return // No show main video info have been found!
            }
            
            var mainVideo:ShowVideoItem? = nil
            if let elem = HTMLParserLite.parse(html: html, startIdx: r.lowerBound){
                let queryMainVideoElem = "div[0]>div[0]>div[0]>a"
                let queryMainCoverImageElem = "div[0]>div[0]>div"
                let queryMainVideoTitleElem = "div[0]>div[0]>div[1]"
                let queryDescriptionElem = "div[1]>div[1]"
                
                if let mainVideoCoverElem = elem.lookupChildElement(queryMainCoverImageElem){
                    mainVideoCoverImageUrl = HTMLParserUtility.extractBackgroundImageUrl(from: mainVideoCoverElem, urlFirstPart: Settings.websiteUrl)
                }
                
                if let mainVideoElem = elem.lookupChildElement(queryMainVideoElem){
                    mainVideoPageUrl = "\(Settings.websiteUrl)\(mainVideoElem.attributes["href"] ?? "")"
                }
                
                if let mainVideoTitleElem = elem.lookupChildElement(queryMainVideoTitleElem){
                    mainVideoTitle = mainVideoTitleElem.innerHTML(originalHtml: html)
                }
                
                if let descriptionElem = elem.lookupChildElement(queryDescriptionElem){
                    showDesc = descriptionElem.innerHTML(originalHtml: html)
                }
                
                mainVideo = ShowVideoItem(id: HTMLParserUtility.extractLastParamOfUrl(url: mainVideoPageUrl ?? ""), title: mainVideoTitle ?? "", videoPageUrl: mainVideoPageUrl, coverImageUrl: mainVideoCoverImageUrl)
            }
            
            let videoUrlBySection = parseVideoSections(html: html, start: r.upperBound)
            self.downloadVideoSections(dicRequestUrlBySection: videoUrlBySection, completion: { (dicVideoItemsBySection) in
                completion(ShowDetail(pageUrl: pageUrl, name: self.showName, desc: showDesc, mainVideo: mainVideo, videoItemsBySection: dicVideoItemsBySection))
            })
        }
        else{
            completion(nil)
        }
    }
    
    func parseVideoSections(html:String, start:String.Index) -> [String:URLRequest]{
        /*
         <div class="video_hed nino blue">&nbsp&nbsp&nbsp&nbsp;გადაცემების არქივი</div>
         <div class="line"></div>
         <div id="prods"></div>
         <script>load_videos('ka','43','');</script>
         //http://rustavi2.ge/includes/shows_sub_ajax.php?l=ka&id=43&pos=0&mode=&_=1543780631518
         */
        
        var dicRequestUrlBySection:[String:URLRequest] = [:]
        var rangeStartIdx = start
        while let rSectionStart = html.range(of: "<div class=\"video_hed nino blue\"", options: .caseInsensitive, range: rangeStartIdx..<html.endIndex, locale: nil){
            if(rSectionStart.isEmpty){
                break;
            }
            
            guard let elem = HTMLParserLite.parse(html: html, startIdx: rSectionStart.lowerBound) else {
                break;
            }
            
            var sectionName = elem.innerHTML(originalHtml: html)
            sectionName = String.replace(sectionName, search: ["&nbsp;","&nbsp"], replaceWith: "")
            
            rangeStartIdx = rSectionStart.upperBound
            guard let r = html.range(of: "load_videos(", options: .caseInsensitive, range: rangeStartIdx..<html.endIndex, locale: nil) else{
                break;
            }
            
            //<script>load_videos('ka','43',1);</script>
            if let rEnd = html.range(of: ")", options: .caseInsensitive, range: r.upperBound..<html.endIndex, locale: nil){
                if(rEnd.isEmpty){
                    break;
                }
                
                let sParams = String(html[r.upperBound..<rEnd.lowerBound])
                let arrParams = sParams.split(separator:",")
                let trimChars:[Character] = [" ", "'"]
                
                if(arrParams.count == 3){
                    let lang = String(arrParams[0]).trimStart(trimChars).trimEnd(trimChars)
                    let id = String(arrParams[1]).trimStart(trimChars).trimEnd(trimChars)
                    let mode = String(arrParams[2]).trimStart(trimChars).trimEnd(trimChars)
                    let queryParams = "l=\(lang)&id=\(id)&pos=0&mode=\(mode)&_=1543780631518"
                    print("\(Settings.urlShowVideosXHR)?\(queryParams)")
                    
                    if let reqUrl = URL(string: "\(Settings.urlShowVideosXHR)?\(queryParams)") {
                        dicRequestUrlBySection[sectionName] = URLRequest(url: reqUrl)
                    }
                }
            }
            
            rangeStartIdx = r.upperBound
        }
        
        return dicRequestUrlBySection
    }
    
    func parseVideoItems(html:String) -> [ShowVideoItem]? {
        /*
         <div class="ireport_bl margin_null">
         <div class="ph" style="background-image:url(/shows_videos/37972.jpg)"><a href="/ka/video/37972?v=2"></a></div>
         <div class="title rioni"><a href="/ka/video/37972?v=2" class="link white">რომელმაც საქართველო შეძრა - კურიერის გამოძიება</a></div>
         </div>
         
         <div class="ireport_bl">
         <div class="ph" style="background-image:url(/shows_videos/37478.jpg)"><a href="/ka/video/37478?v=2"></a></div>
         <div class="title rioni"><a href="/ka/video/37478?v=2" class="link white">ნინია კაკაბაძე შაბათის კურიერში</a></div>
         </div>
         */
        
        var items:[ShowVideoItem]? = nil
        if let elem = HTMLParserLite.parse(html: html, startIdx: html.startIndex){
            if let children = elem.children{
                for c in children{
                    var coverImageUrl:String?
                    var videoPageUrl:String?
                    var title:String?
                    
                    if let bkgndImageElem = c.lookupChildElement("div[0]"){
                        coverImageUrl = HTMLParserUtility.extractBackgroundImageUrl(from: bkgndImageElem, urlFirstPart: Settings.websiteUrl)
                    }
                    
                    if let videoLinkAndTitleElem = c.lookupChildElement("div[1]>a"){
                        videoPageUrl = "\(Settings.websiteUrl)\(videoLinkAndTitleElem.attributes["href"] ?? "")"
                        title = videoLinkAndTitleElem.innerHTML(originalHtml: html)
                    }
                    if(items == nil){
                        items = []
                    }
                    if(videoPageUrl == nil){
                        continue
                    }
                    items?.append(ShowVideoItem(id: HTMLParserUtility.extractLastParamOfUrl(url: videoPageUrl ?? ""), title: title ?? "", videoPageUrl: videoPageUrl, coverImageUrl: coverImageUrl))
                }
            }
        }
        
        return items
    }
    
    func downloadVideoSections(dicRequestUrlBySection:[String:URLRequest], completion: @escaping ([String:[ShowVideoItem]?]) -> Void) {
        let parseClosure:((Data)->[ShowVideoItem]?) = {(data) -> [ShowVideoItem]? in
            var videoItems:[ShowVideoItem]? = nil
            if let htmlData = String(data: data, encoding: String.Encoding.utf8){
                let htmlContent:String = "<div>\(htmlData)</div>"
                videoItems = self.parseVideoItems(html: htmlContent)
            }
            return videoItems
        }
        
        downloadAndParseMultiple(dicRequestUrlByName: dicRequestUrlBySection, parseDataClosure: parseClosure, completion: completion)
    }
}
