//
//  Settings.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/28/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public class Settings {
    public static let appGroupId: String = "group.com.zqrtalent.Rustavi2Tv"
    public static let sharedFrameworkAppId: String = "com.zqrtalent.Rustavi2TvShared"
    
    public static let widgetUrlScheme: String = "rustavi2widget"
    public static let widgetAction_LiveVideo: String = "live"
    public static let widgetAction_News: String = "news"
    public static let widgetAction_NewsDetail: String = "newsdetail"
    
    public static let liveStreamUrl: String = "http://md-store4.tulix.tv/rustavi2/index.m3u8"
    
    public static let websiteUrl: String = "http://www.rustavi2.ge"
    public static let urlNews: String = "http://www.rustavi2.ge/ka"
    public static let urlNewsDetail: String = "http://www.rustavi2.ge/ka/news"
    public static let urlNewsPhotos: String = "http://www.rustavi2.ge/news_photos"
    public static let urlNewsArchivePaged: String = "http://rustavi2.ge/ka/news/page-"
    
    public static let urlShows: String = "http://www.rustavi2.ge/ka/shows"
    public static let urlShowVideosXHR: String = "http://rustavi2.ge/includes/shows_sub_ajax.php"
    
    
    public static let apiLatestNews: String = "https://rustavi2webapi.herokuapp.com/api/v1/news/latest"
    public static let apiNewsDetails: String = "https://rustavi2webapi.herokuapp.com/api/v1/news/{id}"
    public static let apiShows: String = "https://rustavi2webapi.herokuapp.com/api/v1/shows"
    public static let apiShowDetails: String = "https://rustavi2webapi.herokuapp.com/api/v1/shows/{id}"
    
}
