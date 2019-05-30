//
//  NewsTableViewController.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/22/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import UIKit
import Rustavi2TvShared
typealias NewsItemsWithDate = (Date,[NewsItem])

class NewsTableViewController: UITableViewController {
    
    private var isLoading: Bool = false
    private let imageStorage = NewsImageStorage()
    var newsItems: [NewsItem]?
    
    internal lazy var refreshCtrl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NewsTableViewController.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.loadNews(1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add Live video bar item.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Live", style: .done, target: self, action: #selector(onLiveVideo(sender:)))
        
        // Add refresh control
        self.tableView?.addSubview(refreshCtrl)
        
        // Load news
        loadNews(1)
    }
    
    @objc func onLiveVideo(sender: UIBarButtonItem){
        print("Live video")
        HLSVideoPlayerHelper.playVideo(url: Settings.liveStreamUrl_prod, viewCtrl: self)
    }
    
    private func loadNews(_ pageNum:UInt){
        self.isLoading = true
        
//        let apiClient = HttpClient()
//        apiClient.GetJsonArray(Settings.apiLatestNews) { (newsItems:[NewsItem], errorStr:String?) in
//            DispatchQueue.main.async {
//                if let err = errorStr{
//                    print("error returned \(err)")
//                }
//                else{
//                    self.updateNewsItems(newsItems, pageNum: pageNum)
//                }
//
//                self.isLoading = false
//                self.tableView?.reloadData()
//
//                // Delete cover images except for ones we care.
//                let itemIds = newsItems.map({ (item) -> String in item.id})
//                let deletedCoverImages = self.imageStorage.deleteNewsImageFilesWithId(except: itemIds)
//                print("\(deletedCoverImages) news (Cover small, large etc) images have been deleted!")
//
//                self.refreshCtrl.endRefreshing()
//            }
//        }
        
        let scraperArchive = NewsArchiveWebScraper()
        scraperArchive.RetrieveNewsPaged(pageNum) { (pageNum, newsItems, errorStr) in
            DispatchQueue.main.async {
                if let err = errorStr{
                    print("error returned \(err)")
                }
                else{
                    self.updateNewsItems(newsItems, pageNum: pageNum)
                }

                self.isLoading = false
                self.tableView?.reloadData()

                // Delete cover images except for ones we care.
                if let itemIds = newsItems?.map({ (item) -> String in item.id}){
                    let deletedCoverImages = self.imageStorage.deleteNewsImageFilesWithId(except: itemIds)
                    print("\(deletedCoverImages) news (Cover small, large etc) images have been deleted!")
                }

                self.refreshCtrl.endRefreshing()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newsItem = self.newsItems?[indexPath.row]{
            print(newsItem.id)
            NewsDetailViewController.initialize(newsId: newsItem.id)
        }
    }
    
    static let cellId = "defaultcell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewController.cellId, for: indexPath) as! NewsItemTableViewCell
        
        let item = self.newsItems?[indexPath.row]
        cell.newsTitle.text = item?.title ?? ""
        cell.time.text = item?.time?.asDateTimeString() ?? ""
        cell.coverImage.image = item?.coverImage ?? nil
        
        if(item?.coverImage == nil){
            let index = indexPath
            let newsId = item?.id ?? ""
            let coverImageUrl = item?.coverImageUrl ?? ""
            
            if let imageUrl = URL(string: coverImageUrl) {
                imageStorage.readCoverImage(withId: newsId, imageUrl: imageUrl) { (image) in
                    // What if row order changes??
                    if let newsItem = self.newsItems?[indexPath.row] {
                        newsItem.coverImage = image
                    }

                    if let updateCell = self.tableView.cellForRow(at: index) as! NewsItemTableViewCell?{
                        updateCell.coverImage.image = image
                    }
                }
            }
        }
        
        return cell
    }
}
