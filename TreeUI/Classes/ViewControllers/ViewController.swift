//
//  ViewController.swift
//  TreeUI
//
//  Created by TamNguyen on 9/19/16.
//  Copyright © 2016 TamNguyen. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var totalMoneyValueLabel: UILabel!
    @IBOutlet weak var shadownLine: UIImageView!
    @IBOutlet weak var treeView: EzyTreeView!
    
    fileprivate var dataSource: [User] = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.totalMoneyValueLabel.text = ""
        self.shadownLine.image = Utils.middleStretchImagedName("shadowLine.png")
        self.registerNotification()
        self.treeView.baseVerticalLineColor = UIColor.red
        self.treeView.subBaseVerticalLineColor = UIColor.yellow
        self.treeView.treeViewDataSource = self
        
        self.loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    fileprivate func registerNotification() {
    }
    
    func receiveNotificationUpdateTotalMoney(_ notif: Notification) {
        if let totalMoney = notif.object as? NSNumber {
            DispatchQueue.main.async(execute: { 
                self.totalMoneyValueLabel.text = "$\(totalMoney.floatValue)"
            })
        }
    }
    
    fileprivate func loadData() {        
        // Load local data from Data.json
        let path = Bundle.main.path(forResource: "Data", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let jsonOrigin = JSON(data: jsonData as! Data,
                              options: JSONSerialization.ReadingOptions.allowFragments,
                              error: nil)
        self.processReportFromJSON(jsonOrigin)
    }
    
    private func processReportFromJSON(_ jsonData: JSON?) {
        if let originJson = jsonData {
            if let arrData = originJson[kKeyRows].array {
                var dictUser: [Int: User] = [Int: User]()
                
                for jsonElem in arrData {
                    var baseElem = jsonElem[kKeyUserLevel1]
                    var subBaseElem = jsonElem[kKeyUserLevel2]
                    var detailElem = jsonElem[kKeyTarget]
                    if (baseElem == nil || baseElem[kKeyUserID].exists() == false) {
                        if (subBaseElem != nil && subBaseElem[kKeyUserID].exists() == true) {
                            baseElem = subBaseElem
                            subBaseElem = detailElem
                            detailElem = nil
                        } else {
                            if (detailElem != nil && detailElem[kKeyUserID].exists() == true) {
                                baseElem = detailElem
                                subBaseElem = nil
                                detailElem = nil
                            } else {
                                continue
                            }
                        }
                    }
                    
                    var currUser = User.parserUserFromJSON(jsonData: baseElem)
                    if let tempUser = dictUser[currUser.userId] {
                        currUser = tempUser
                    }
                    self.processRowData(currUser, subBaseJSON: subBaseElem, detailJSON: detailElem)
                    dictUser[currUser.userId] = currUser
                }
                for key in dictUser.keys {
                    self.dataSource.append(dictUser[key]!)
                }
            }
            self.treeView.reloadTreeView()
        }
    }
    
    private func processRowData(_ baseUser: User, subBaseJSON: JSON?, detailJSON: JSON?) {
        if (subBaseJSON?[kKeyUserID].exists() == true) {
            var subUser = User.parserUserFromJSON(jsonData: subBaseJSON!)
            if (baseUser.childrenUsers == nil) {
                baseUser.childrenUsers = [User]()
            }
            if let childUser = self.getChildOfUser(baseUser, idChild: subUser.userId) {
                subUser = childUser
            } else {
                baseUser.childrenUsers?.append(subUser)
            }
            if (detailJSON?[kKeyUserID].exists() == true) {
                self.processRowData(subUser, subBaseJSON: detailJSON, detailJSON: nil)
            }
        } else {
            if (detailJSON?[kKeyUserID].exists() == true) {
                let subUser = User.parserUserFromJSON(jsonData: detailJSON!)
                if (baseUser.childrenUsers == nil) {
                    baseUser.childrenUsers = [User]()
                }
                if (self.getChildOfUser(baseUser, idChild: subUser.userId) == nil) {
                    baseUser.childrenUsers!.append(subUser)
                }
            }
        }
    }
    
    private func getChildOfUser(_ user: User, idChild: Int) -> User? {
        for child in user.childrenUsers! {
            if (child.userId == idChild) {
                return child
            }
        }
        
        return nil
    }
}

extension ViewController : EzyTreeViewDataSource {
    
    func treeViewNumberOfBaseRow() -> Int {
        return self.dataSource.count
    }
    
    func treeViewDataBaseCell(baseCellIndexPath: IndexPath) -> (image: String, name: String, money: CGFloat) {
        if (baseCellIndexPath.row >= 0 && baseCellIndexPath.row < self.dataSource.count) {
            let currObj = self.dataSource[baseCellIndexPath.row]
            
            return (currObj.avatarUrl, currObj.fullName, CGFloat(currObj.accountBalance))
        }
        return ("Unknow", "Unknow", 0.0)
    }

    func treeViewBaseCellHasChild(baseCellIndexPath: IndexPath) -> Bool {
        if (baseCellIndexPath.row >= 0 && baseCellIndexPath.row < self.dataSource.count) {
            let currObj = self.dataSource[baseCellIndexPath.row]
            
            if (currObj.childrenUsers != nil) {
                if (currObj.childrenUsers!.count > 0) {
                    return true
                }
            }
        }
        return false
    }
    
    func treeViewNumberOfSubBaseCell(baseCellIndexPath indexPathBaseCell: IndexPath) -> Int {
        if (indexPathBaseCell.row >= 0 && indexPathBaseCell.row < self.dataSource.count) {
            let currObj = self.dataSource[indexPathBaseCell.row]
            var childs = [User]()
            if (currObj.childrenUsers != nil) {
                if (currObj.childrenUsers?.count != 0) {
                    childs = currObj.childrenUsers!
                }
            }
            return childs.count
        }
        return 0
    }
    func treeViewDataSubBaseCell(baseCellIndexPath: IndexPath,
                                 subBaseIndexPath: IndexPath) -> (image: String, name: String, money: CGFloat) {
        if (baseCellIndexPath.row >= 0 && baseCellIndexPath.row < self.dataSource.count) {
            let currObj = self.dataSource[baseCellIndexPath.row]
            if (currObj.childrenUsers != nil) {
                if (currObj.childrenUsers!.count != 0) {
                    let childs = currObj.childrenUsers!
                    if (subBaseIndexPath.row >= 0 && subBaseIndexPath.row < childs.count) {
                        let subObj = childs[subBaseIndexPath.row]
                        
                        return (subObj.avatarUrl, subObj.fullName, CGFloat(subObj.earningsPoint))
                    }
                }
            }
        }
        return ("Unknow", "Unknow", 0.0)
    }
    func treeViewSubBaseCellHasChild(baseCellIndexPath: IndexPath, subBaseIndexPath: IndexPath) -> Bool {
        if (baseCellIndexPath.row >= 0 && baseCellIndexPath.row < self.dataSource.count) {
            let currObj = self.dataSource[baseCellIndexPath.row]
            if (currObj.childrenUsers != nil) {
                if (currObj.childrenUsers!.count != 0) {
                    let childs = currObj.childrenUsers!
                    if (subBaseIndexPath.row >= 0 && subBaseIndexPath.row < childs.count) {
                        let currChildObj = childs[subBaseIndexPath.row]
                        
                        if (currChildObj.childrenUsers != nil) {
                            if (currChildObj.childrenUsers!.count > 0) {
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    //MARK: Cell detail
    func treeViewNumberOfDetailCell(baseCellIndexPath: IndexPath, subBaseIndexPath: IndexPath) -> Int {
        if (baseCellIndexPath.row >= 0 && baseCellIndexPath.row < self.dataSource.count) {
            let currObj = self.dataSource[baseCellIndexPath.row]
            if (currObj.childrenUsers != nil) {
                if (currObj.childrenUsers!.count != 0) {
                    let childs = currObj.childrenUsers!
                    if (subBaseIndexPath.row >= 0 && subBaseIndexPath.row < childs.count) {
                        let currChildObj = childs[subBaseIndexPath.row]
                        
                        if (currChildObj.childrenUsers != nil) {
                            return currChildObj.childrenUsers!.count
                        }
                    }
                }
            }
        }
        return 0
    }
    
    func treeViewDataDetailCell(baseCellIndexPath: IndexPath,
                                subBaseIndexPath: IndexPath,
                                detailCellIndexPath: IndexPath) -> (image: String, name: String, money: CGFloat) {
        if (baseCellIndexPath.row >= 0 && baseCellIndexPath.row < self.dataSource.count) {
            let currObj = self.dataSource[baseCellIndexPath.row]
            if (currObj.childrenUsers != nil) {
                if (currObj.childrenUsers!.count != 0) {
                    let childs = currObj.childrenUsers!
                    if (subBaseIndexPath.row >= 0 && subBaseIndexPath.row < childs.count) {
                        let subObj = childs[subBaseIndexPath.row]
                        
                        if (subObj.childrenUsers != nil) {
                            if (subObj.childrenUsers!.count > 0) {
                                let details = subObj.childrenUsers!
                                if (detailCellIndexPath.row >= 0 &&
                                    detailCellIndexPath.row < details.count) {
                                    let currChildObj = details[detailCellIndexPath.row]
                                    
                                    return (currChildObj.avatarUrl,
                                            currChildObj.fullName,
                                            CGFloat(currChildObj.earningsPoint))
                                }
                            }
                        }
                    }
                }
            }
        }
        return ("Unknow", "Unknow", 0.0)
    }
    
    // Height for cell at index path: at base level
    func treeViewHeightForDetailRow() -> CGFloat {
        return 40.0
    }
}

