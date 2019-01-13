//
//  ShowVideoImageStorage.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 12/18/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class ShowVideosImageStorage: ImageFileStorage{
    public init(showName:String?) {
        super.init(storeDirectoryName: "shows-images-\(showName ?? "unknown")")
    }
    
    private let imageLoadingQueue = DispatchQueue(label: "queue-show_videos-image-loader") // Serial
    
    public func readShowVideoCoverImage(id:String, imageUrl:URL?, completionClosure: @escaping (UIImage?) -> ()){
        let fileName = "img-\(id)"
        readImage(withName: fileName, imageUrl: imageUrl, usingQueue: self.imageLoadingQueue, processDownloadedImageHandler: nil, completionClosure: completionClosure)
    }
}
