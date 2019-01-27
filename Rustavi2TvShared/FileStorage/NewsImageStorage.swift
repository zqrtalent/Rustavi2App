//
//  NewsImageStorage.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/18/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

/*
 func getDownloadSize(url: URL, completion: @escaping (Int64, Error?) -> Void) {
 let timeoutInterval = 5.0
 var request = URLRequest(url: url,
 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
 timeoutInterval: timeoutInterval)
 request.httpMethod = "HEAD"
 URLSession.shared.dataTask(with: request) { (data, response, error) in
 let contentLength = response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
 completion(contentLength, error)
 }.resume()
 }
 */

public class NewsImageStorage : ImageFileStorage {
    public init() {
        super.init(storeDirectoryName: "news-images")
    }
    
    private let imageLoadingQueue = DispatchQueue(label: "queue-news-images-loader") // Serial
    
    public func deleteNewsImageFilesWithId(except:[String]) -> Int{
        guard except.count > 0 else {
            return 0
        }
        let exceptSmNames = except.map { (s) -> String in "sm-\(s)"}
        let exceptLgNames = except.map { (s) -> String in "lg-\(s)"}
        return self.deleteFilesWithName(except: exceptSmNames + exceptLgNames)
    }
    
    public func deleteCoverImageFilesWithId(except:[String]) -> Int{
        guard except.count > 0 else {
            return 0
        }
        let exceptNames = except.map { (s) -> String in "sm-\(s)"}
        return self.deleteFilesWithName(except: exceptNames)
    }
    
    public func deleteDetailCoverImageFilesWithId(except:[String]) -> Int{
        guard except.count > 0 else {
            return 0
        }
        let exceptNames = except.map { (s) -> String in "lg-\(s)"}
        return self.deleteFilesWithName(except: exceptNames)
    }
    
    public func readCoverImage(withId id:String, imageUrl:URL?, completionClosure: @escaping (UIImage?) -> ()){
        let fileName = "sm-\(id)"
        readImage(withName: fileName, imageUrl: imageUrl, usingQueue: self.imageLoadingQueue, processDownloadedImageHandler: nil, completionClosure: completionClosure)
    }
    
    public func readDetailCoverImage(withId id:String, imageUrl:URL?, completionClosure: @escaping (UIImage?) -> ()){
        let fileName = "lg-\(id)"
        readImage(withName: fileName, imageUrl: imageUrl, usingQueue: self.imageLoadingQueue, processDownloadedImageHandler: nil, completionClosure: completionClosure)
    }
}
