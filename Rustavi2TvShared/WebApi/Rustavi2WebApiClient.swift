//
//  Rustavi2WebApiClient.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 5/31/19.
//  Copyright © 2019 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class Rustavi2WebApiClient : HttpClient {
    
    public func GetLatestNews(_ responseClosure:@escaping ([NewsItem], String?) -> Void) -> Bool{
        return GetJsonArray(Settings.apiLatestNews, responseClosure: responseClosure)
    }
    
    public func GetNewsDetails(_ id: String, responseClosure:@escaping (NewsDetail, String?) -> Void) -> Bool{
        return GetJson(String.replace(Settings.apiNewsDetails, search:["{id}"], replaceWith: id), responseClosure: responseClosure)
    }
    
    public func GetNewsVideoDetails(_ videoId: String, responseClosure:@escaping (ItemVideoDetails, String?) -> Void) -> Bool{
        return GetJson(String.replace(Settings.apiNewsVideoDetails, search:["{id}"], replaceWith: videoId), responseClosure: responseClosure)
    }
    
    public func GetShows(_ responseClosure:@escaping ([ShowItem], String?) -> Void) -> Bool{
        return GetJsonArray(Settings.apiShows, responseClosure: responseClosure)
    }
    
    public func GetShowDetails(_ showId: String, responseClosure:@escaping (ShowDetail, String?) -> Void) -> Bool{
        let showIdUrlEncoded = showId.urlEncode() ?? showId;
        return GetJson(String.replace(Settings.apiShowDetails, search:["{id}"], replaceWith:showIdUrlEncoded), responseClosure: responseClosure)
    }
    
    public func GetShowVideoDetails(_ showId: String, videoId: String, responseClosure:@escaping (ItemVideoDetails, String?) -> Void) -> Bool{
        let showIdUrlEncoded = showId.urlEncode() ?? showId;
        return GetJson(String.replace( String.replace(Settings.apiShowVideoDetails, search:["{videoId}"], replaceWith:videoId), search:["{id}"], replaceWith: showIdUrlEncoded),
                       responseClosure: responseClosure)
    }
}
