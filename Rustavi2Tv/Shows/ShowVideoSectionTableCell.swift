//
//  ShowVideoSectionTableCell.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 12/11/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import UIKit
import Rustavi2TvShared

class ShowVideoSectionTableCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var videos: ShowVideosColectionView!
    
    private var videosDataSource: ShowVideosCollectionDataSource!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Code here
    }
    
    public func updateVideos(showId:String, showVideos:[ShowVideoItem]?){
        if videos.delegate == nil {
            videosDataSource = ShowVideosCollectionDataSource(showId: showId, showVideos: showVideos)
            videos.dataSource = videosDataSource
        }
        else{
            videosDataSource.updateItems(showVideos)
        }
        videos.reloadData()
        videos.layoutIfNeeded()
    }
}
