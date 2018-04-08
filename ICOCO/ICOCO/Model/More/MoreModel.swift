//
//  MoreModel.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 23..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation

// MARK: - MoreModel
class MoreModel {
    internal var menus = Array<MoreMenu>()
    
    init() {
        // About
        var aboutMenu = MoreMenu()
        aboutMenu.title = "About"
        aboutMenu.contentUrlStr = SERVICE_INFO_RAW_URL + "/About.txt"
        aboutMenu.content = "ICOCO v1.1.0\n"
        aboutMenu.content?.append("Copyright © 2018 Prangbi.\n\n")
        aboutMenu.content?.append("ICOCO provide crypto currency ICO list and news.\n")
        aboutMenu.content?.append("ICO list from : https://icobench.com\n")
        aboutMenu.content?.append("News from : https://www.ccn.com\n\n")
        aboutMenu.content?.append("Contact : prangbi@gmail.com")
        self.menus.append(aboutMenu)
        
        // Terms
        var termsMenu = MoreMenu()
        termsMenu.title = "Terms"
        termsMenu.contentUrlStr = SERVICE_INFO_RAW_URL + "/Terms.txt"
        termsMenu.content = "Disclaimers\n : All information on ICOCO serve informational purposes only. ICOCO does not provide investment forecast, recommendations or any consulting for that matter. ICOCO cannot be hold responsible for the users' investment decisions.\n\n"
        termsMenu.content?.append("Updated: 2018-01-31")
        self.menus.append(termsMenu)
        
        // Library
        var libraryMenu = MoreMenu()
        libraryMenu.title = "Library"
        libraryMenu.contentUrlStr = SERVICE_INFO_RAW_URL + "/Library.txt"
        libraryMenu.content = "Alamofire\n : https://github.com/Alamofire/Alamofire\n : Elegant HTTP Networking in Swift.\n\n"
        libraryMenu.content?.append("CryptoSwift\n : https://github.com/krzyzanowskim/CryptoSwift\n : CryptoSwift is a growing collection of standard and secure cryptographic algorithms implemented in Swift.\n\n")
        libraryMenu.content?.append("ObjectMapper\n : https://github.com/Hearst-DD/ObjectMapper\n : Simple JSON Object mapping written in Swift.\n\n")
        libraryMenu.content?.append("SwiftSoup\n : https://github.com/scinfu/SwiftSoup\n : Pure Swift HTML Parser, with best of DOM, CSS, and jquery (Supports Linux, iOS, Mac, tvOS, watchOS).\n\n")
        libraryMenu.content?.append("SWXMLHash\n : https://github.com/drmohundro/SWXMLHash\n : Simple XML parsing in Swift.")
        self.menus.append(libraryMenu)
    }
}

// MARK: - Function
extension MoreModel {
    // Section
    func getSectionCount() -> Int {
        return self.menus.count
    }
    
    func getSectionTitle(section: Int) -> String? {
        return self.menus[section].title
    }
    
    // Row
    func getRowCount(section: Int) -> Int {
        return 1
    }
    
    func getRowData(indexPath: IndexPath) -> String? {
        return self.menus[indexPath.section].content
    }
}
