//
//  PrHttpRequest+News.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 23..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import Foundation
import ObjectMapper
import SWXMLHash

extension PrHttpRequest {
    func getNewsList(
        page: Int,
        success: ((Int?, Array<NewsInfo>?) -> Void)?,
        failure: ((Int?, String?) -> Void)?)
    {
        let urlStr = String(format: PrHttpRequest.CCN_API_URL + "/feed", arguments: [])
        var params: Dictionary<String, Any> = [:]
        params["paged"] = page
        self.requestJsonCcn(method: "GET", urlStr: urlStr, params: params, success: { (statusCode, resultValue, data) in
            var resultObject: Array<NewsInfo>? = nil
            if nil != resultValue {
                resultObject = try? SWXMLHash.parse(resultValue!)["rss"]["channel"]["item"].value()
            }
            success?(statusCode, resultObject)
        }) { (statusCode, errMsg) in
            failure?(statusCode, errMsg)
        }
    }
}
