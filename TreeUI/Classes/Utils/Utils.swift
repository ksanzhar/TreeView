//
//  Utils.swift
//  ezyRides
//
//  Created by TamNguyen on 8/19/16.
//  Copyright © 2016 daturit. All rights reserved.
//

import UIKit
import Foundation

class Utils: NSObject {
    
    class func hexStringToUIColor(_ hexStr: String) -> UIColor {
        let hex = hexStr.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    class func stretchImagedName(_ imageName: String, leftPadding: Int,
                                 topPadding: Int) -> UIImage {
        var image = UIImage(named: imageName)
        image = image!.stretchableImage(withLeftCapWidth: leftPadding, topCapHeight:topPadding)
        return image!
    }
    
    class func stretchImagedName(_ imageName: String, topPadding: Int) -> UIImage {
        var image = UIImage(named: imageName)
        image = image!.stretchableImage(withLeftCapWidth: Int(image!.size.width/2),
                                                       topCapHeight:Int(image!.size.height/2) + topPadding)
        return image!
    }
    
    class func middleStretchImagedName(_ imageName: String) -> UIImage {
        var image = UIImage(named: imageName)
        image = image!.stretchableImage(withLeftCapWidth: Int(image!.size.width/2),
                                                       topCapHeight:Int(image!.size.height/2))
        return image!
    }
}
