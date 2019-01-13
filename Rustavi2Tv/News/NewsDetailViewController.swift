//
//  NewsDetailViewController.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/26/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import UIKit
import AVKit
import WebKit
import Rustavi2TvShared

class NewsDetailViewController: StretchyLayoutViewController {
    public var newsId: String?
    private var isLoading: Bool = false
    private var newsDetail: NewsDetail?
    private let imageStorage = NewsImageStorage()
    
    public static func initialize(newsId:String){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let newsDetailViewCtrl = sb.instantiateViewController(withIdentifier: "newsDetailViewId") as! NewsDetailViewController
        newsDetailViewCtrl.newsId = newsId
        
        let tabBarCtrl = AppDelegate.rootViewCtrl as! UITabBarController?
        if let currViewCtrl = tabBarCtrl?.selectedViewController{
            let navCtrl = currViewCtrl as! UINavigationController
            navCtrl.pushViewController(newsDetailViewCtrl, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        loadNewsDetail()
    }
    
    @objc override func onPlayVideo(sender: UIButton){
        if let videoUrl = newsDetail?.videoUrl{
            HLSVideoPlayerHelper.playVideo(url: videoUrl, viewCtrl: self)
        }
    }
    
    private func loadNewsDetail(){
        self.isLoading = true
        
        let scraper = NewsDetailWebScraper()
        scraper.RetrieveNewsDetail(self.newsId ?? "") { (detail, errorStr) in
            self.isLoading = false
            
            if let err = errorStr{
                print("error returned \(err)")
                return
            }
            else{
                self.newsDetail = detail
            }
            
            let coverImage = detail?.coverImageUrl ?? ""
            if let coverImageUrl = URL(string: coverImage) {
                self.imageStorage.readDetailCoverImage(withId: detail?.id ?? "", imageUrl: coverImageUrl, completionClosure: { (image) in
                    if let coverImage = image{
                        detail?.coverImage = coverImage
                        self.updateArticleImage(image: coverImage)
                    }
                    else{
                        print("Failed loading news detail coverimage: \(coverImage)")
                    }
                })
            }
            
            DispatchQueue.main.async {
                if let detailHtml = self.newsDetail?.storyDetail{
                    let fontStyle = "<style type=\"text/css\"> html { -webkit-text-size-adjust: 100%;} body { font-size: 1.0em; } </style>"
                    let header = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
                    self.updateArticleDetail(title: self.newsDetail?.title ?? "", time: self.newsDetail?.time?.asDateTimeString() ?? "", textAsHtml: "<html>\(header)<body>\(fontStyle)\(detailHtml)</body></html>")
                }
                
                // Load video url.
                self.loadNewsVideoUrl();
            }
        }
    }
    
    private func loadNewsVideoUrl(){
        if(self.newsDetail?.videoUrl != nil){
            return;
        }
        
        if let videoFrameUrl = self.newsDetail?.videoFrameUrl {
            let scraper = NewsVideoUrlWebScraper()
            scraper.RetrieveNewsVideoUrl(videoFrameUrl) { (videoUrl, errorDesc) in
                if(videoUrl != nil){
                    self.newsDetail?.videoUrl = videoUrl
                    
                    DispatchQueue.main.async {
                        // Enable play video button.
                        self.allowPlayVideo(allowPlay: true)
                    }
                }
            }
        }
    }
}
