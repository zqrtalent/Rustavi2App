//
//  ShowVideosColectionView.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 12/17/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import UIKit
import Rustavi2TvShared

class ShowVideosCollectionDataSource: NSObject, UICollectionViewDataSource {
    private var showId: String;
    private var showVideos: [ShowVideoItem]?
    private let imageStorage:ShowVideosImageStorage?
    private static let cellId = "defaultcell"
    
    private var updater: CollectionViewUpdater?
    
    init(showId:String, showVideos: [ShowVideoItem]?) {
        self.showId = showId
        self.showVideos = showVideos
        self.imageStorage = ShowVideosImageStorage(showName: showId)
    }
    
    deinit {
        print("~ShowVideosCollectionDataSource")
        updater?.cancelUpdate()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showVideos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowVideosCollectionDataSource.cellId, for: indexPath) as! ShowVideoSectionCell
        cell.prepareForReuse()
        
        // Configure the cell
        cell.title.text = showVideos?[indexPath.row].title
        cell.imageView.image = showVideos?[indexPath.row].coverImage
        
        if let showVideo = self.showVideos?[indexPath.row]{
            cell.enablePlayVideoButton(showId: showId, videoId: showVideo.id, videoPageUrl: showVideo.videoPageUrl ?? "")
        }
                
        if(self.updater == nil){
            self.updater = CollectionViewUpdater(view: collectionView)
        }
        
        if(showVideos?[indexPath.row].coverImage == nil){
            let index = indexPath
            let coverImage = showVideos?[indexPath.row].coverImageUrl ?? ""
            let id = showVideos?[indexPath.row].id ?? "0"
            
            if let coverImageUrl = URL(string: coverImage) {
                imageStorage?.readShowVideoCoverImage(id: id, imageUrl: coverImageUrl) { (image) in
                    if let videoItem = self.showVideos?[indexPath.row] {
                        videoItem.coverImage = image
                        
                        if let updateCell = collectionView.cellForItem(at: index) as! ShowVideoSectionCell?{
                            updateCell.imageView.image = image
                        }
                        else{
                            self.updater?.updateCell(at: index, after: .now() + 1)
                            
                            // TODO: Crushed app once while scroling.
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                                print("reload: \(index.row)")
//                                collectionView.reloadItems(at: [index])
//                            })
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    public func updateItems(_ items:[ShowVideoItem]?){
        if(self.showVideos?.count ?? 0 == 0){
            self.showVideos = items
        }
        else{
            var itemsMerged:[ShowVideoItem] = []
            if let oldItems = self.showVideos{
                
                for item in items!{
                    let found = oldItems.first(where: { (i) -> Bool in return i.title == item.title})
                    if let found = found{
                        // Image has been changed.
                        if(found.coverImageUrl != item.coverImageUrl){
                            found.coverImage = nil
                            found.coverImageUrl = item.coverImageUrl
                        }
                        
                        itemsMerged.append(found)
                    }
                    else{
                        itemsMerged.append(item)
                    }
                }
            }
            
            self.showVideos = itemsMerged
        }
    }
}

class ShowVideosColectionView: UICollectionView {
}
