//
//  HLSVideoPlayerHelper.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/28/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import AVKit

public class HLSVideoPlayerHelper {
    
    public static func playVideo(url:String, viewCtrl: UIViewController?){
        let videoURL = URL(fileURLWithPath: url)
        let player = AVPlayer(url: videoURL)
        
        let playerCtrl = AVPlayerViewController()
        playerCtrl.player = player
        
        if let viewCtrl = viewCtrl{
            viewCtrl.present(playerCtrl, animated: true) {
                playerCtrl.player!.play()
            }
        }
        else{
            
        }
    }
    
    public static func playVideoEmbedeed(url:String, view: UIView){
        let videoURL = URL(fileURLWithPath: url)
        let player = AVPlayer(url: videoURL)
        
        let playerLayer = AVPlayerLayer()
        playerLayer.player = player
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        player.play()
        
        /*
         let player = AVPlayer(URL: url!)
         let playerLayer = AVPlayerLayer(player: player)
         playerLayer.frame = CGRectMake(0,50,screenSize.width, screenSize.height)
         self.view.layer.addSublayer(playerLayer)
         player.play()
         */
        
        /*
         let player = AVPlayer(URL: url!)
         let playerController = AVPlayerViewController()
         playerController.player = player
         
         playerController.view.frame = CGRectMake(0, 50, screenSize.width, 240)
         self.view.addSubview(playerController.view)
         self.addChildViewController(playerController)
         
         player.play()
         */
    }
}
