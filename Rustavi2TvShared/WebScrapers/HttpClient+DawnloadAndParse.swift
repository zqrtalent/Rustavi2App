//
//  WebScrapper.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/26/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public extension HttpClient {
    
    public func downloadAndParseMultiple<TKey,TRequestResult>(dicRequestUrlByName:[TKey:URLRequest], parseDataClosure:@escaping (Data)->TRequestResult?, completion: @escaping ([TKey:TRequestResult?]) -> Void) {
        var resultByName:[TKey:TRequestResult?] = [:]
        guard dicRequestUrlByName.count > 0 else {
            completion(resultByName)
            return;
        }
        
        let queue = DispatchQueue(label: "com.zqrtalent.queue.DownloadAndParse") // Serial queue
        DispatchQueue.global().async {
            let group = DispatchGroup()
            
            for elem in dicRequestUrlByName {
                group.enter()
                
                self.downloadAndParse(request: elem.value, parseDataClosure: parseDataClosure, callback: { (result) in
                    queue.async {
                        resultByName[elem.key] = result
                        group.leave()
                    }
                })
            }
            
            group.notify(queue: DispatchQueue.main){
                // Completion closure
                completion(resultByName)
            }
        }
    }
    
    public func downloadAndParse<TResult>(request:URLRequest, parseDataClosure:@escaping (Data)->TResult?, callback: @escaping ((TResult?)-> Void)){
        let ses = URLSession(configuration: .default)
        ses.dataTask(with: request, completionHandler: { (data, resp, error) in
            var result:TResult? = nil
            defer {
                // Invoke callback.
                callback(result)
                // Clean up session
                ses.invalidateAndCancel()
            }
            
            guard error == nil && data != nil else{
                return // HTTP error.
            }
            
            result = parseDataClosure(data!)
        }).resume()
    }
}
