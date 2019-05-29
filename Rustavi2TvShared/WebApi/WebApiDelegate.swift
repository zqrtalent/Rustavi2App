//
//  WebApiDelegate.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 5/26/19.
//  Copyright © 2019 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

protocol WebApiDelegate{
    func onNewsItems(_ items: [NewsItem]?)
    func onNewsDetails(_ itemDetail: NewsDetail?)
    
    func onShowsItems(_ items: [ShowItem]?)
    func onShowDetails(_ showDetail: ShowDetail?)
}
