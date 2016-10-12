//
//  ServicesManager.swift
//  TreeUI
//
//  Created by TamNguyen on 10/11/16.
//  Copyright © 2016 TamNguyen. All rights reserved.
//

import UIKit

class ServicesManager {
    
    static let shareInstance: ServicesManager = ServicesManager()
    
    var dataCenter: DataCenter!
    
    private init() {
        self.dataCenter = DataCenter()
    }
}
