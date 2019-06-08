//
//  ShowTableViewController.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 12/16/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import UIKit
import Rustavi2TvShared

class ShowTableViewController: UITableViewController {
    
    var details: ShowDetail?
    private var isLoading: Bool = false
    private var imageStorage:ShowVideosImageStorage?
    
    private var showPageUrl: String?
    private var showId: String?
    private var showName: String?
    private var mainVideoUrl: String?
    
    internal lazy var refreshCtrl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NewsTableViewController.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.loadShowDetails()
    }
    
    public static func initialize(id: String, showName:String, showPageUrl:String){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewCtrl = sb.instantiateViewController(withIdentifier: "showTableViewId") as! ShowTableViewController
        viewCtrl.showPageUrl = showPageUrl
        viewCtrl.showName = showName
        viewCtrl.showId = id;
        
        let tabBarCtrl = AppDelegate.rootViewCtrl as! UITabBarController?
        if let currViewCtrl = tabBarCtrl?.selectedViewController{
            let navCtrl = currViewCtrl as! UINavigationController
            navCtrl.pushViewController(viewCtrl, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add refresh control
        self.tableView?.addSubview(refreshCtrl)
        // Remove separator lines
        //self.tableView?.separatorStyle = .none
        
        // Set title
        self.navigationItem.title = self.showName
        
        // Initialize image storage
        self.imageStorage = ShowVideosImageStorage(showName: self.showName)
        
        // Load news
        loadShowDetails()
    }
    
    private func loadShowDetails(){
        guard let showId = self.showId else{
            return;
        }
        
        self.isLoading = true
        let apiClient = Rustavi2WebApiClient()
        apiClient.GetShowDetails(showId) { (details:ShowDetail, errorStr:String?) in
            DispatchQueue.main.async {
                if let err = errorStr{
                    print("error returned \(err)")
                    self.isLoading = false
                    self.refreshCtrl.endRefreshing()
                }
                else{
                    self.updateShowDetail(details)
                    self.isLoading = false
                    self.tableView?.reloadData()
                    self.refreshCtrl.endRefreshing()
                }
            }
        }
        
//        let scraper = ShowDetailWebScraper()
//        scraper.RetrieveShowDetails(showName: self.showName ?? "", showPageUrl: self.showPageUrl!) { (details, errorStr) in
//            DispatchQueue.main.async {
//                if let err = errorStr{
//                    print("error returned \(err)")
//                    self.isLoading = false
//                    self.refreshCtrl.endRefreshing()
//                }
//                else{
//                    self.updateShowDetail(details)
//                    self.isLoading = false
//                    self.tableView?.reloadData()
//                    self.refreshCtrl.endRefreshing()
//                }
//            }
//        }
    }
    
    private func updateShowDetail(_ details:ShowDetail?){
        self.details = details
    }
    
    enum TableCellSection: Int {
        case mainVideoCell = 0, videoSectionCell = 1
    }
    
    public static let mainVideoCell = "mainvideocell"
    public static let videoSectionCell = "videosectioncell"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case TableCellSection.mainVideoCell.rawValue:
            return 266.0
        default: // TableCellSection.videoSectionCell.rawValue:
            return 210.0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TableCellSection.mainVideoCell.rawValue:
            return 1
        default: // TableCellSection.videoSectionCell.rawValue:
            return self.details?.videoItemsBySection?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == TableCellSection.mainVideoCell.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowTableViewController.mainVideoCell, for: indexPath) as! ShowMainVideoTableCell
            
            if let mainVideo = details?.mainVideo{
                cell.title.text = mainVideo.title
                
                if let imageUrl = URL(string: mainVideo.coverImageUrl ?? "") {
                    imageStorage?.readShowVideoCoverImage(id: mainVideo.id, imageUrl: imageUrl) { (image) in
                        // What if row order changes??
                        self.details?.mainVideo?.coverImage = image
                        
                        if let updateCell = self.tableView.cellForRow(at: indexPath) as! ShowMainVideoTableCell?{
                            updateCell.coverImage.image = image
                        }
                    }
                }
                
                cell.coverImage.addPlayButton(target: self, onPlayVideoAction: #selector(onPlayMainVideo(sender:)))
            }
            else{
                cell.title.text = ""
                cell.coverImage.image = nil
            }
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowTableViewController.videoSectionCell, for: indexPath) as! ShowVideoSectionTableCell
            
            if let videoItemsBySection = self.details?.videoItemsBySection ?? nil{
                let elem = videoItemsBySection[videoItemsBySection.index(videoItemsBySection.startIndex, offsetBy: indexPath.row)]
                cell.title.text = elem.key
                cell.updateVideos(showId: self.showId ?? "", showVideos: elem.value)
            }
            
            return cell
        }
    }
    
    @objc func onPlayMainVideo(sender: UIButton){
        print("play main video")
        if let videoUrl = self.mainVideoUrl{
            HLSVideoPlayerHelper.playVideo(url: videoUrl, viewCtrl: self)
        }
        else{
            guard let showId = self.details?.id else{
                return
            }
            
            guard let videoId = self.details?.mainVideo?.id else{
                return
            }
            
            let apiClient = Rustavi2WebApiClient()
            apiClient.GetShowVideoDetails(showId, videoId: videoId){ (videoDetails: ItemVideoDetails, errorStr:String?) in
                DispatchQueue.main.async {
                    if let err = errorStr{
                        print("error returned \(err)")
                    }
                    else{
                        if let videoUrl = videoDetails.videoUrl{
                            self.mainVideoUrl = videoUrl
                            HLSVideoPlayerHelper.playVideo(url: videoUrl, viewCtrl: self)
                        }
                    }
                }
            }
        }
        
//        if let mainVideoPageUrl = self.details?.mainVideo?.videoPageUrl{
//            let scraper = ShowVideoWebScraper()
//            scraper.RetrieveShowVideoInfo(mainVideoPageUrl) { (videoInfo, errorStr) in
//                DispatchQueue.main.async {
//                    if let err = errorStr{
//                        print("error returned \(err)")
//                    }
//                    else{
//                        if let videoUrl = videoInfo?.videoUrl{
//                            self.mainVideoUrl = videoUrl
//                            HLSVideoPlayerHelper.playVideo(url: videoUrl, viewCtrl: self)
//                        }
//                    }
//                }
//            }
//        }
    }
}
