//
//  NewsItemTableViewCell.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/22/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import UIKit

class NewsItemTableViewCell : UITableViewCell {
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Code here
    }
}
