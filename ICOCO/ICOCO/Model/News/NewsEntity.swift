//
//  NewsEntity.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 23..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation
import ObjectMapper
import SWXMLHash
import SwiftSoup

// MARK: - NewsInfo
struct NewsInfo: XMLIndexerDeserializable, Mappable {
    var title: String? = nil
    var link: String? = nil
    var pubDate: String? = nil
    var creator: String? = nil
    var description: String? = nil
    var commentCount: Int? = nil
    var categoryList: Array<String>? = nil

    // MARK: XMLIndexerDeserializable
    init(
        title: String?,
        link: String?,
        pubDate: String?,
        creator: String?,
        description: String?,
        commentCount: Int?,
        categoryList: Array<String>?)
    {
        self.title = title
        self.link = link
        self.pubDate = pubDate
        self.creator = creator
        self.description = description
        self.commentCount = commentCount
        self.categoryList = categoryList
        
        if let desc = self.description {
            self.description = try? SwiftSoup.parse(desc).text()
        }
    }
    
    static func deserialize(_ node: XMLIndexer) throws -> NewsInfo {
        return try NewsInfo(
            title           : node["title"].value(),
            link            : node["link"].value(),
            pubDate         : node["pubDate"].value(),
            creator         : node["dc:creator"].value(),
            description     : node["description"].value(),
            commentCount    : node["slash:comments"].value(),
            categoryList    : node["category"].value()
        )
    }
    
    // MARK: Mappable
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.title          <- map["title"]
        self.link           <- map["link"]
        self.pubDate        <- map["pubDate"]
        self.creator        <- map["creator"]
        self.description    <- map["description"]
        self.categoryList   <- map["categoryList"]
        self.commentCount   <- map["commentCount"]
    }
}
