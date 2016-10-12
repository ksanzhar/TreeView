//
//  DataCenter.swift
//  TreeUI
//
//  Created by TamNguyen on 10/11/16.
//  Copyright © 2016 TamNguyen. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

let kKeyRows            =   "rows"
let kKeyUserLevel1      =   "user_level_1"
let kKeyUserLevel2      =   "user_level_2"
let kKeyTarget          =   "target"

class DataCenter: NSObject {
    func getReportYear(_ year: String, successBlock: @escaping ((JSON?) -> Swift.Void)) {
        let userDefault = UserDefaults.standard
        if let accessToken = userDefault.string(forKey: "AccessToken") {
            let url = "http://st-api.thousandhands.net/api/v1/reports/referral_year"
            let parameters = ["year" : "\(year)"]
            
            let headers : [String: String] = [
                "Authorization": "Bearer \(accessToken)",
                "Accept-Language": "en"
            ]
            
            do {
                let opt = try HTTP.GET(url, parameters: parameters, headers: headers, requestSerializer: JSONParameterSerializer())
                opt.start { response in
                    let json = JSON(data: response.data)
                    successBlock(json)
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                successBlock(nil)
            }
        } else {
            successBlock(nil)
        }
    }
}
