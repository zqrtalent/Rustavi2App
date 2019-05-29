//
//  WebScrapper.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/26/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public extension HttpClient {
    
    public func GetJsonArray<TArrayItem: Serializable>(_ getUrl:String, responseClosure:@escaping ([TArrayItem], String?) -> Void) -> Bool{
        guard let url = URL(string: getUrl) else{
            return false
        }
        
        var req = URLRequest(url: url)
        req.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return self.GetJsonArray(req, responseClosure: responseClosure);
    }
    
    public func GetJsonArray<TArrayItem: Serializable>(_ request:URLRequest, responseClosure:@escaping ([TArrayItem], String?) -> Void) -> Bool{
        _session = session;
        guard let task = _session?.dataTask(with: request) else{
            // Clean up session
            _session?.invalidateAndCancel()
            _session = nil
            return false;
        }
        
        receivedData = Data()
        receivedDataCallback =  {
            if let data = self.receivedData{
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                
                var items:[TArrayItem] = []
                if let jsonArr = json as? [Any]{
                    for jsonItem in jsonArr{
                        if let jsonObj = jsonItem as? [String: Any]{
                            items.append(TArrayItem(json: jsonObj))
                        }
                    }
                }
                
                responseClosure(items, nil)
            }
        }
        
        task.resume()
        return true
    }
    
    public func GetJson<TResponse: Serializable>(_ getUrl:String, responseClosure:@escaping (TResponse, String?) -> Void) -> Bool{
        guard let url = URL(string: getUrl) else{
            return false
        }

        var req = URLRequest(url: url)
        req.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return self.GetJson(req, responseClosure: responseClosure);
    }
    
    public func GetJson<TResponse: Serializable>(_ request:URLRequest, responseClosure:@escaping (TResponse, String?) -> Void) -> Bool{
        _session = session;
        guard let task = _session?.dataTask(with: request) else{
            // Clean up session
            _session?.invalidateAndCancel()
            _session = nil
            return false;
        }
        
        receivedData = Data()
        receivedDataCallback =  {
            if let data = self.receivedData{
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let jsonObj = json as? [String: Any]{
                    let respData = TResponse(json: jsonObj);
                    responseClosure(respData, nil)
                }
            }
        }
        
        task.resume()
        return true
    }
}
