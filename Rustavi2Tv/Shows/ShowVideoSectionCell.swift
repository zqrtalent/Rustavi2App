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
    private var videoPageUrl:String?
    private var videoUrl:String?
    
    public func enablePlayVideoButton(videoPageUrl:String){
        if(self.playButton == nil){
            self.videoPageUrl = videoPageUrl
            self.playButton = imageView.addPlayButton(target: self, onPlayVideoAction: #selector(onPlayShowVideo(sender:)))
        }
        else{
            if(self.videoPageUrl ?? "" != videoPageUrl){
                self.videoPageUrl = videoPageUrl
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
            guard self.videoPageUrl != nil else{
                return
            }
         
            let scraper = ShowVideoWebScraper()
            scraper.RetrieveShowVideoInfo(self.videoPageUrl!) { (videoInfo, errorStr) in
                DispatchQueue.main.async {
                    if let err = errorStr{
                        print("error returned \(err)")
                    }
                    else{
                        if let viewCtrl = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController{
                            if let videoUrl = videoInfo?.videoUrl{
                                self.videoUrl = videoUrl
                                HLSVideoPlayerHelper.playVideo(url: videoUrl, viewCtrl: viewCtrl)
                            }
                        }
                    }
                }
            }
            
        }
    }
}
