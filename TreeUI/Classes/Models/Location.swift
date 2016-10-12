//
//  Location.swift
//  ezyCourierCustomer
//
//  Created by Do Tri on 3/14/16.
//  Copyright © 2016 ezyPlanet. All rights reserved.
//

import UIKit

class Location {
    var latitude: NSNumber = 0
    var longitude: NSNumber = 0
    var full_address : String = ""

    var city : String = ""
    var number : String = ""

    var route : String = ""
    var locality : String = ""
    var subLocality : String = ""
    var suburb : String = ""
    var shortLocality : String = ""
    var shortSubLocality : String = ""
    var areaLevel2 : String = ""
    var shortAreaLevel2 : String = ""
    var route2 : String = ""
    var phone_prefix : String = ""
    var country_code : String = ""
    var country : String = ""
    var state : String = ""

    init(locLat: NSNumber, locLng: NSNumber) {
        latitude = locLat
        longitude = locLng
    }
}
