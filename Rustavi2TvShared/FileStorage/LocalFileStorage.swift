//
//  LocalFileStorage.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/17/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import os
import Foundation


public class LocalFileStorage : NSObject {
    
    init(storeDirectoryName:String) {
        self.storeDirectoryName = storeDirectoryName
    }
    
    let storeDirectoryName:String
    
    lazy var storeDirectoryUrl:URL? = {
        guard let docUrl = self.fileManager.containerURL(forSecurityApplicationGroupIdentifier: Settings.appGroupId) else{
        //guard let docUrl = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).last else{
            return nil
        }
        return docUrl.appendingPathComponent(self.storeDirectoryName)
    }()
    
    var fileManager:FileManager = {
       return FileManager.default
    }()
    
    public func storeFile(as fileName:String, contents:Data) -> Bool{
        guard let storeUrl = storeDirectoryUrl else{
            return false
        }
        
        let fileUrl = storeUrl.appendingPathComponent(fileName)
        if(!self.fileManager.fileExists(atPath: storeUrl.path, isDirectory: nil)){
            do {
                try self.fileManager.createDirectory(at: storeUrl, withIntermediateDirectories: false, attributes: nil)
            }
            catch{
                print("Failed creating directory with: \(error)")
                return false
            }
        }
        
        return self.fileManager.createFile(atPath: fileUrl.path, contents: contents, attributes: nil)
    }
    
    public func readFile(as fileName:String) -> Data?{
        guard let storeUrl = storeDirectoryUrl else{
            return nil
        }
        let fileUrl = storeUrl.appendingPathComponent(fileName)
        return fileManager.contents(atPath:fileUrl.path)
    }
    
}
