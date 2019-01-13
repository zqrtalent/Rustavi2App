//
//  ShowsTableViewController.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 11/14/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import UIKit
import Rustavi2TvShared

class ShowsCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "DefaultCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var showsItems: [ShowItem]?
    private var isLoading: Bool = false
    private let imageStorage = ShowsImageStorage()
    
    private var updater: CollectionViewUpdater?
    
    internal lazy var refreshCtrl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ShowsCollectionViewController.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.loadShows()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add refresh control
        collectionView?.addSubview(refreshCtrl)

        // Load shows
        loadShows()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.showsItems?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath) as! ShowCollectionViewCell
        cell.prepareForReuse()
        
        // Configure the cell
        cell.title.text = showsItems?[indexPath.row].name
        cell.imageView.image = showsItems?[indexPath.row].coverImage
        
        if(showsItems?[indexPath.row].coverImage == nil){
            let index = indexPath
            let coverImage = showsItems?[indexPath.row].coverImageUrl ?? ""
            let name = showsItems?[indexPath.row].name ?? ""
            
            if(self.updater == nil){
                self.updater = CollectionViewUpdater(view: collectionView)
            }
            
            if let coverImageUrl = URL(string: coverImage) {
                imageStorage.readShowCoverImageSmall(name: name, imageUrl: coverImageUrl) { (image) in
                    if let newsItem = self.showsItems?[indexPath.row] {
                        newsItem.coverImage = image
                    }
                    
                    if let updateCell = collectionView.cellForItem(at: index) as! ShowCollectionViewCell?{
                        updateCell.imageView.image = image
                    }
                    else{
                        self.updater?.updateCell(at: indexPath, after: .now() + 1)
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                            self.collectionView.reloadItems(at: [indexPath])
//                        })
                    }
                }
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = self.showsItems?[indexPath.item]{
            if let pageUrl = item.pageUrl {
                ShowTableViewController.initialize(showName: item.name, showPageUrl: pageUrl)
            }
        }
    }
    
    private func loadShows(){
        self.isLoading = true
        let scraper = ShowsWebScraper()
        scraper.RetrieveShows { (showsItems, errorStr) in
            DispatchQueue.main.async {
                if let err = errorStr{
                    print("error returned \(err)")
                    self.isLoading = false
                    self.refreshCtrl.endRefreshing()
                }
                else{
                    self.updateShows(showsItems)
                    self.isLoading = false
                    self.collectionView?.reloadData()
                    self.refreshCtrl.endRefreshing()
                }
            }
        }
    }
    
    private func updateShows(_ items:[ShowItem]!){
        if(self.showsItems?.count ?? 0 == 0){
            self.showsItems = items
        }
        else{
            var itemsMerged:[ShowItem] = []
            if let oldItems = self.showsItems{

                for item in items{
                    let found = oldItems.first(where: { (i) -> Bool in return i.name == item.name})
                    if let found = found{
                        // Image has been changed.
                        if(found.coverImageUrl != item.coverImageUrl){
                            found.coverImage = nil
                            found.coverImageUrl = item.coverImageUrl
                        }

                        itemsMerged.append(found)
                    }
                    else{
                        itemsMerged.append(item)
                    }
                }
            }

            self.showsItems = itemsMerged
        }
    }
}
