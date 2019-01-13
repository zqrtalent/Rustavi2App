//
//  ShowsImageStorage.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/18/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class ShowsImageStorage: ImageFileStorage{
    public init() {
        super.init(storeDirectoryName: "shows-images")
    }
    
    private let imageLoadingQueue = DispatchQueue(label: "queue-shows-images-loader") // Serial
    
    public func readShowCoverImageSmall(name:String, imageUrl:URL?, completionClosure: @escaping (UIImage?) -> ()){
        let fileName = "sm-\(name)"
        readImage(withName: fileName, imageUrl: imageUrl, usingQueue: self.imageLoadingQueue, processDownloadedImageHandler: nil, completionClosure: completionClosure)
    }
    
    public func readShowCoverImageLarge(name:String, imageUrl:URL?, completionClosure: @escaping (UIImage?) -> ()){
        let fileName = "lg-\(name)"
        readImage(withName: fileName, imageUrl: imageUrl, usingQueue: self.imageLoadingQueue, processDownloadedImageHandler: nil, completionClosure: completionClosure)
    }
}
