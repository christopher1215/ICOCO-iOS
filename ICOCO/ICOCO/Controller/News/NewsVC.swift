//
//  NewsVC.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 23..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - NewsVC
class NewsVC: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variable
    internal var model = NewsModel()
    internal var indicator: UIActivityIndicatorView? = nil
    internal var refreshControl = UIRefreshControl()
    internal var noContentsLabel = UILabel()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellId = NewsCell.CellId
        self.tableView.register(UINib(nibName: cellId, bundle: Bundle.main), forCellReuseIdentifier: cellId)
        self.tableView.estimatedRowHeight = 160.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.refreshControl.addTarget(self, action: #selector(NewsVC.refreshData(_:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        
        self.noContentsLabel.center.x = self.tableView.center.x
        self.noContentsLabel.frame.origin.y = 100.0
        self.tableView.addSubview(self.noContentsLabel)
        
        self.indicator = UiUtil.makeActivityIndicator(parentView: self.view)
        self.getFirstNewsListPage()
    }
}

// MARK: - Event
extension NewsVC {
    @objc func refreshData(_ sender: UIRefreshControl) {
        self.getFirstNewsListPage()
    }
}

// MARK: - Function
extension NewsVC {
    internal func getFirstNewsListPage() {
        self.indicator?.startAnimating()
        self.model.getFirstNewsListPage(success: {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.indicator?.stopAnimating()
        }) { (errMsg) in
            self.indicator?.stopAnimating()
            if nil != errMsg {
                MessageUtil.showAlert(targetVc: self, title: nil, message: errMsg, completion: {
                    self.refreshControl.endRefreshing()
                })
            } else {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    internal func getNextNewsListPage() {
        self.indicator?.startAnimating()
        self.model.getNextNewsListPage(success: {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.indicator?.stopAnimating()
        }) { (errMsg) in
            self.refreshControl.endRefreshing()
            self.indicator?.stopAnimating()
            if nil != errMsg {
                MessageUtil.showAlert(targetVc: self, title: nil, message: errMsg, completion: {
                    self.refreshControl.endRefreshing()
                })
            } else {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - UITableView
extension NewsVC: UITableViewDataSource, UITableViewDelegate {
    internal func updateNoContentsLabel(rowCount: Int) {
        if false == NetStatusUtil.shared.canConnectToInternet() {
            self.noContentsLabel.text = "Can't connect to internet."
            self.noContentsLabel.sizeToFit()
            self.noContentsLabel.center.x = self.tableView.center.x
            self.noContentsLabel.isHidden = false
        } else if 0 == rowCount {
            self.noContentsLabel.text = "No contents."
            self.noContentsLabel.sizeToFit()
            self.noContentsLabel.center.x = self.tableView.center.x
            self.noContentsLabel.isHidden = false
        } else {
            self.noContentsLabel.isHidden = true
            self.noContentsLabel.text = nil
        }
    }
    
    // Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.model.getRowCount()
        self.updateNoContentsLabel(rowCount: count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.model.getRowData(row: indexPath.row)
        let pubDate = DateTimeUtil.changeNewsPubDateFormat(dateStr: data.pubDate)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: NewsCell.CellId) as! NewsCell
        cell.setData(
            title: data.title,
            creator: data.creator,
            pubDate: pubDate
        )
        return cell
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (false == self.indicator?.isAnimating), (false == self.model.noMorePage),
            (indexPath.row == self.model.getRowCount() - 1), (true == NetStatusUtil.shared.canConnectToInternet())
        {
            self.getNextNewsListPage()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.model.getRowData(row: indexPath.row)
        if let link = data.link, let host = URL(string: link)?.host {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let webVC = storyboard.instantiateViewController(withIdentifier: "WebVC") as? WebVC {
                webVC.title = host
                webVC.setData(url: data.link)
                self.navigationController?.pushViewController(webVC, animated: true)
            }
        }
    }
}
