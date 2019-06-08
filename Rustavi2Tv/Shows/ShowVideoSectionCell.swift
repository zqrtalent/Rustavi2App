//
//  ShowVideoSectionCell.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 12/11/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import UIKit
import Rustavi2TvShared

class ShowVideoSectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    private var playButton:UIButton?
    private var showId: String = ""
    private var videoId: String = ""
    private var videoPageUrl:String?
    private var videoUrl:String?
    
    public func enablePlayVideoButton(showId: String, videoId: String, videoPageUrl:String){
        self.showId = showId
        
        if(self.playButton == nil){
            self.videoId = videoId
            self.videoPageUrl = videoPageUrl
            self.playButton = imageView.addPlayButton(target: self, onPlayVideoAction: #selector(onPlayShowVideo(sender:)))
        }
        else{
            if(self.videoId != videoId){
                self.videoPageUrl = videoPageUrl
                self.showId = showId
                self.videoId = videoId
                self.videoUrl = nil
            }
        }
    }
    
    @objc func onPlayShowVideo(sender:UIButton){
        print("play show video")
        if let videoUrl = self.videoUrl{
            if let viewCtrl = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController{
                HLSVideoPlayerHelper.playVideo(url: videoUrl, viewCtrl: viewCtrl)
            }
        }
        else{
            let apiClient = Rustavi2WebApiClient()
            apiClient.GetShowVideoDetails(self.showId, videoId: videoId){ (videoDetails: ItemVideoDetails, errorStr:String?) in
                DispatchQueue.main.async {
                    if let err = errorStr{
                        print("error returned \(err)")
                    }
                    else{
                        if let viewCtrl = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController{
                            if let videoUrl = videoDetails.videoUrl{
                                self.videoUrl = videoUrl
                                HLSVideoPlayerHelper.playVideo(url: videoUrl, viewCtrl: viewCtrl)
                            }
                        }
                    }
                }
            }
            
//            guard self.videoPageUrl != nil else{
//                return
//            }
//
//            let scraper = ShowVideoWebScraper()
//            scraper.RetrieveShowVideoInfo(self.videoPageUrl!) { (videoInfo, errorStr) in
//                DispatchQueue.main.async {
//                    if let err = errorStr{
//                        print("error returned \(err)")
//                    }
//                    else{
//                        if let viewCtrl = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController{
//                            if let videoUrl = videoInfo?.videoUrl{
//                                self.videoUrl = videoUrl
//                                HLSVideoPlayerHelper.playVideo(url: videoUrl, viewCtrl: viewCtrl)
//                            }
//                        }
//                    }
//                }
//            }
            
        }
    }
}
