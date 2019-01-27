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
    
    public func deleteFilesWithName(except:[String]) -> Int{
        guard except.count > 0 else {
            return 0
        }
        
        guard let files = self.enumerateFiles() else{
            return 0
        }
        
        let set = Set(except)
        let deleteNames = files.filter { (s) -> Bool in !set.contains(s)}
        return self.deleteFiles(fileNames: deleteNames)
    }
    
    public func deleteFiles(fileNames:[String]) -> Int{
        guard let storeUrl = storeDirectoryUrl else{
            return 0
        }
        
        var deletedCt = 0
        for name in fileNames {
            do{
                try fileManager.removeItem(at: storeUrl.appendingPathComponent(name))
                deletedCt += 1
            }
            catch{
                // TODO: log error
            }
        }
        return deletedCt
    }
    
    public func enumerateFiles() -> [String]?{
        guard let storeUrl = storeDirectoryUrl else{
            return nil
        }
        
        var fileNames:[String]? = nil
        do {
            let contents = try fileManager.contentsOfDirectory(at: storeUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            fileNames = contents.map({url -> String in url.lastPathComponent })
        }
        catch{
        }
        
        return fileNames
    }
}
