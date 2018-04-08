//
//  NewsCell.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 24..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - NewsCell
class NewsCell: UITableViewCell {
    // MARK: Static
    static let CellId = "NewsCell"
    
    // MARK: Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Function
extension NewsCell {
    func setData(
        title: String?,
        creator: String?,
        pubDate: String?)
    {
        self.titleLabel.text = title
        self.creatorLabel.text = creator
        self.dateTimeLabel.text = pubDate
    }
}

