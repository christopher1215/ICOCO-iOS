//
//  MoreVC.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 23..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - MoreVC
class MoreVC: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variable
    internal var model = MoreModel()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellId = SimpleCell.CellId
        self.tableView.register(UINib(nibName: cellId, bundle: Bundle.main), forCellReuseIdentifier: cellId)
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

// MARK: - UITableView
extension MoreVC: UITableViewDataSource, UITableViewDelegate {
    // Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.model.getSectionCount()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = self.model.getSectionTitle(section: section)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SimpleCell.CellId) as! SimpleCell
        cell.setData(content: title, showSeparator: true, font: UIFont.boldSystemFont(ofSize: 16.0))
        cell.backgroundColor = .groupTableViewBackground
        return cell
    }
    
    // Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.getRowCount(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = self.model.getRowData(indexPath: indexPath)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SimpleCell.CellId) as! SimpleCell
        cell.setData(content: content, showSeparator: true, font: UIFont.systemFont(ofSize: 13.0))
        return cell
    }
}
