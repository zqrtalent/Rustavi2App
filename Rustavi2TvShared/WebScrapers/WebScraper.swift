//
//  WebScrapper.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/26/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import os
import Compression

typealias NewsCompletionHandlerBlock = ([NewsItem]?, String?) -> Void
typealias NewsArchivePagedCompletionHandlerBlock = (UInt, [NewsItem]?, String?) -> Void
typealias NewsDetailCompletionHandlerBlock = (NewsDetail?, String?) -> Void
typealias NewsVideoUrlCompletionHandlerBlock = (String?, String?) -> Void
typealias ShowsCompletionHandlerBlock = ([ShowItem]?, String?) -> Void
typealias ShowDetailCompletionHandlerBlock = (ShowDetail?, String?) -> Void
typealias ShowVideoCompletionHandlerBlock = (ShowVideoInfo?, String?) -> Void

public class WebScraper : NSObject, URLSessionDataDelegate {
    override init() {
        super.init()
    }
    
    var receivedData: Data?
    var _session: URLSession?
    
    public lazy var session : URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    public func httpGet(_ pageUrl:String) -> Bool{
        guard let url = URL(string: pageUrl) else{
            return false
        }
        
        var req = URLRequest(url: url)
        req.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
        //req.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        req.setValue("text/html", forHTTPHeaderField: "Accept")
        
        _session = session;
        guard let task = _session?.dataTask(with: req) else{
            // Clean up session
            _session?.invalidateAndCancel()
            _session = nil
            return false;
        }
        task.resume()
        return true
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        receivedData?.append(data)
        print("\(dataTask.countOfBytesExpectedToReceive) \(dataTask.countOfBytesReceived) \(receivedData?.count ?? 0)")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let e = error {
            DispatchQueue.main.async {
                self.onDataReceiveCompletedWithError("Error")
            }
        }
        else{
            onDataReceiveCompleted()
        }
        
        // Clean up session
        _session?.invalidateAndCancel()
        _session = nil
    }
    
    public func decodeGzipAsString(_ gzipData:Data) -> String?{
        let decodedCapacity = gzipData.count * 4 //8_000_000
        let decodedDestinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: decodedCapacity)
        let algorithm = COMPRESSION_ZLIB
        
        let decodedString = gzipData.withUnsafeBytes {
            (encodedSourceBuffer: UnsafePointer<UInt8>) -> String in
            let decodedCharCount = compression_decode_buffer(decodedDestinationBuffer,
                                                             decodedCapacity,
                                                             encodedSourceBuffer,
                                                             gzipData.count,
                                                             nil,
                                                             algorithm)
            
            if decodedCharCount == 0 {
                os_log("Failed decoding gzip data", type:OSLogType.error)
                return ""
            }
            
            return String(cString: decodedDestinationBuffer)
        }
        
        return decodedString
    }
    
    open func onDataReceiveCompleted(){
        print("Data receive completed!")
    }
    
    open func onDataReceiveCompletedWithError(_ errorDesc:String){
        print("Error occured - \(errorDesc)")
    }
    
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
