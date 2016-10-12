//
//  User.swift
//  ezyHelpers
//
//  Created by Do Tri on 5/26/16.
//  Copyright © 2016 Do Tri. All rights reserved.
//

import UIKit
import SwiftyJSON

let kKeyUserID          =   "id"

class User {
    
    var isRegisterPartner = false
    var isPartner = false {
        didSet {
            if isPartner {
                isRegisterPartner = false
            }
        }
    }
    var sendNotifications = true
    var verifiedPhone = false
    var avatarImage : UIImage!
    var avatarUrl = ""
    
    var fullName = ""
    var formattedEarnings = ""
    var countryCode = ""
    var country = ""
    var currency = ""
    var language = ""
    var userId : Int = 0
    var taskLiveCount : Int = 0
    var helperRateCount : Int = 0
    var helperStar : CGFloat = 0
    var helperTaskLiveCount : Int = 0
    var taskCount : Int = 0
    var email = ""
    var accountBalance : NSNumber = 0
    var formattedAccountBalance = ""
    var formattedAvailableBalance = ""
    var phone = ""
    var phonePrefix = ""
    var location: Location!
    var skills = [String]()
    var childrenUsers: [User]?
    var earningsPoint: CGFloat = 0
    
    func reset() {
        verifiedPhone = false
        countryCode = ""
        country = ""
        currency = ""
        language = ""
        userId = 0
        fullName = ""
        email = ""
        accountBalance = 0
        phone = ""
        phonePrefix = ""
        avatarUrl = ""
        location = nil
        isPartner = false
    }
    
    func updateDataFromJSON(_ jsonData: JSON) {
        
        let verifyPhone = jsonData["phone_verified"].boolValue
        self.verifiedPhone = verifyPhone
        
        let user_id = jsonData["id"].intValue
        if user_id != 0 {
            self.userId = user_id
        }
        
        let avantarPath = jsonData["avatar_url"].stringValue
        if avantarPath != "" {
            self.avatarUrl = avantarPath
        }
        
        let name = jsonData["full_name"].stringValue
        if name != "" {
            self.fullName = name
        }
        
        let earnings_point = jsonData["earnings_point"].floatValue
        if (earnings_point != 0) {
            self.earningsPoint = CGFloat(earnings_point)
        }
    }
    
    class func parserUserFromJSON(jsonData: JSON) -> User {
        let result = User()
        result.updateDataFromJSON(jsonData)
        return result
    }
}
