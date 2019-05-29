//
//  WebScrapper.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/26/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import os

typealias NewsCompletionHandlerBlock = ([NewsItem]?, String?) -> Void
typealias NewsArchivePagedCompletionHandlerBlock = (UInt, [NewsItem]?, String?) -> Void
typealias NewsDetailCompletionHandlerBlock = (NewsDetail?, String?) -> Void
typealias NewsVideoUrlCompletionHandlerBlock = (String?, String?) -> Void
typealias ShowsCompletionHandlerBlock = ([ShowItem]?, String?) -> Void
typealias ShowDetailCompletionHandlerBlock = (ShowDetail?, String?) -> Void
typealias ShowVideoCompletionHandlerBlock = (ShowVideoInfo?, String?) -> Void

public class HttpClient : NSObject, URLSessionDataDelegate {
    public override init() {
        super.init()
    }
    
    var receivedData: Data?
    var receivedDataCallback: (() -> Void)?
    var _session: URLSession?
    
    public lazy var session : URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    public func GetHtml(_ pageUrl:String) -> Bool{
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
    
    open func onDataReceiveCompleted(){
        print("Data receive completed!")
        
        if let callback = receivedDataCallback{
            callback()
        }
    }
    
    open func onDataReceiveCompletedWithError(_ errorDesc:String){
        print("Error occured - \(errorDesc)")
    }
}
