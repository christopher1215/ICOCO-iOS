//
//  NewsModel.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 23..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation
import SWXMLHash

// MARK: - NewsModel
class NewsModel {
    internal let request = PrHttpRequest()
    internal var currentPage = 1
    internal(set) var noMorePage = false
    internal var newsList = Array<NewsInfo>()
}

// MARK: - Function
extension NewsModel {
    // Row
    func getRowCount() -> Int {
        return self.newsList.count
    }
    
    func getRowData(row: Int) -> NewsInfo {
        return self.newsList[row]
    }
}

// MARK: - Request
extension NewsModel {
    func getFirstNewsListPage(success: (() -> Void)?, failure: ((String?) -> Void)?) {
        let page = 1
        self.noMorePage = false
        self.request.getNewsList(page: page, success: { (statusCode, newsArr) in
            self.currentPage = page
            self.newsList.removeAll()
            if nil == newsArr || 0 == newsArr!.count {
                self.noMorePage = true
            } else {
                self.newsList.append(contentsOf: newsArr!)
            }
            success?()
        }) { (statusCode, errMsg) in
            failure?(errMsg)
        }
    }
    
    func getNextNewsListPage(success: (() -> Void)?, failure: ((String?) -> Void)?) {
        let page = self.currentPage + 1
        self.request.getNewsList(page: page, success: { (statusCode, newsArr) in
            self.currentPage = page
            if 1 >= page {
                self.newsList.removeAll()
            }
            if nil == newsArr || 0 == newsArr!.count {
                self.noMorePage = true
            } else {
                self.newsList.append(contentsOf: newsArr!)
            }
            success?()
        }) { (statusCode, errMsg) in
            failure?(errMsg)
        }
    }
}
