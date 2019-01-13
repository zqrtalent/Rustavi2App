//
//  BaseImageStorage.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/18/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//
import Foundation

typealias DownloadedImageProcessHandler = (UIImage?) -> UIImage?

public class ImageFileStorage : LocalFileStorage{
    
    func readImage(withName fileName:String, imageUrl:URL?, usingQueue:DispatchQueue?, processDownloadedImageHandler: DownloadedImageProcessHandler?, completionClosure: @escaping (UIImage?) -> ()){
        if let imageData = readFile(as: fileName){
            DispatchQueue.main.async {
                completionClosure(UIImage(data: imageData))
            }
        }
        else{
            if let imageUrl = imageUrl{
                (usingQueue ?? DispatchQueue.global()).async {
                    do {
                        let data = try Data.init(contentsOf: imageUrl)
                        if var image = UIImage(data: data) {
                            if(processDownloadedImageHandler != nil){
                                image = processDownloadedImageHandler!(image) ?? image
                            }
                            
                            // Store file
                            if(self.storeFile(as: fileName, contents: data)){
                                print("\(fileName) - saved")
                            }
                            else{
                                print("\(fileName) - not saved")
                            }
                            
                            DispatchQueue.main.async {
                                completionClosure(image)
                            }
                        }
                    }
                    catch{
                        print("Failed to load \(imageUrl)")
                        DispatchQueue.main.async {
                            completionClosure(nil)
                        }
                    }
                }
            }
            else{
                completionClosure(nil)
            }
        }
    }
}
