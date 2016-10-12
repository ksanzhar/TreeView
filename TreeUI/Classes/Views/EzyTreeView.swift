//
//  EzyTreeView.swift
//  TreeUI
//
//  Created by TamNguyen on 9/19/16.
//  Copyright © 2016 TamNguyen. All rights reserved.
//

import UIKit

public let kNotificationReloadTree = "kNotificationReloadTree"

protocol EzyTreeViewDataSource {
    //MARK: Base Cell
    // Number row in tree view: at base level
    func treeViewNumberOfBaseRow() -> Int
    // Data for cell at index path
    func treeViewDataBaseCell(baseCellIndexPath: IndexPath) -> (image: String, name: String, money: CGFloat)
    // Base cell has child
    func treeViewBaseCellHasChild(baseCellIndexPath: IndexPath) -> Bool
    
    //MARK: Cell Sub base
    // Number cell of sub base cell at index path
    func treeViewNumberOfSubBaseCell(baseCellIndexPath: IndexPath) -> Int
    // Data cell of sub base cell at index path
    func treeViewDataSubBaseCell(baseCellIndexPath: IndexPath,
                                 subBaseIndexPath: IndexPath) -> (image: String, name: String, money: CGFloat)
    func treeViewSubBaseCellHasChild(baseCellIndexPath: IndexPath, subBaseIndexPath: IndexPath) -> Bool
    
    //MARK: Cell detail
    // Number detail cell
    func treeViewNumberOfDetailCell(baseCellIndexPath: IndexPath, subBaseIndexPath: IndexPath) -> Int
    // Data detail cell
    func treeViewDataDetailCell(baseCellIndexPath: IndexPath,
                                 subBaseIndexPath: IndexPath,
                                 detailCellIndexPath: IndexPath) -> (image: String, name: String, money: CGFloat)
    
    // Height for cell at index path: at base level
    func treeViewHeightForDetailRow() -> CGFloat
}

class EzyTreeView: UIView {

    // MARK: Public variable
    var treeViewDataSource: EzyTreeViewDataSource! {
        didSet {
            self.treeCell.treeViewDataSource = self.treeViewDataSource
        }
    }
    
    // Color vertical line main cell
    var baseVerticalLineColor: UIColor = Utils.hexStringToUIColor("#7e7e7e")
    
    // Color vertical line sub cell
    var subBaseVerticalLineColor: UIColor = Utils.hexStringToUIColor("#4f4f4f")
    
    // MARK: Font and Color for Root Cell
    // Font for title label root cell
    var mainTitleRootFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    
    // Color for title label root cell
    var mainTitleRootColor: UIColor = Utils.hexStringToUIColor("#444444")
    
    // Font for value label root cell
    var mainValueRootFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    
    // Color for value label root cell
    var mainValueRootColor: UIColor = Utils.hexStringToUIColor("#45a3c2")
    
    // MARK: Font and Color for Sub Root Cell
    // Font for title label sub root cell
    var mainTitleSubRootFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    
    // Color for title label sub root cell
    var mainTitleSubRootColor: UIColor = Utils.hexStringToUIColor("#444444")
    
    // Font for value label sub root cell
    var mainValueSubRootFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    
    // Color for value label sub root cell
    var mainValueSubRootColor: UIColor = Utils.hexStringToUIColor("#45a3c2")
    
    // MARK: Font and Color for Detail Cell
    // Font for title label detail cell
    var mainTitleDetailFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    
    // Color for title label detail cell
    var mainTitleDetailColor: UIColor = Utils.hexStringToUIColor("#444444")
    
    // Font for value label detail cell
    var mainValueDetailFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    
    // Color for value label detail cell
    var mainValueDetailColor: UIColor = Utils.hexStringToUIColor("#45a3c2")
    
    // MARK: Private variable
    fileprivate var mainTreeTableView: UITableView!
    fileprivate var treeCell: TreeTableViewCell!
    fileprivate var dataExpandRow: [Int: AnyObject] =  [Int: AnyObject]()
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.createTreeView()
        self.registerNotification()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createTreeView()
        self.registerNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.createTreeView()
        self.registerNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.mainTreeTableView.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainTreeTableView.frame = self.bounds
    }
    
    fileprivate func createTreeView() {
        if (self.mainTreeTableView == nil) {
            let cellnib = Bundle.main.loadNibNamed("TreeTableViewCell", owner:nil, options: nil)
            
            if ((cellnib?.count)! > 0) {
                treeCell = cellnib?.first as! TreeTableViewCell
                treeCell.treeViewDataSource = self.treeViewDataSource
                treeCell.treeProtocol = self
            } else {
                fatalError("Can't load TreeTableViewCell")
            }
            
            self.mainTreeTableView = UITableView(frame: self.frame, style: .plain)
            if (self.mainTreeTableView == nil) {
                fatalError("Can't create tree view")
            }
            self.mainTreeTableView.allowsSelection = true
            self.mainTreeTableView.separatorStyle = .none
            self.mainTreeTableView.separatorColor = UIColor.clear
            self.mainTreeTableView.delegate = self
            self.mainTreeTableView.dataSource = self
            
            self.mainTreeTableView.tableFooterView = UIView()
            self.mainTreeTableView.register(UINib(nibName: "TreeTableViewCell", bundle: nil),
                                               forCellReuseIdentifier: "TreeTableViewCell")
            
            self.mainTreeTableView.register(UINib(nibName: "ChildTreeTableViewCell", bundle: nil),
                                              forCellReuseIdentifier: "ChildTreeTableViewCell")
            
            self.addSubview(self.mainTreeTableView)
        }
    }

    // MARK: Notification
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(self.receiveNotificationReloadTree(_:)),
                                                         name: NSNotification.Name(rawValue: kNotificationReloadTree),
                                                         object: nil)
    }
    
    func receiveNotificationReloadTree(_ notif: Notification) {
        self.mainTreeTableView.reloadData()
    }
    
    //MARK: Public function
    public func reloadTreeView() {
        DispatchQueue.main.async {
            if (self.mainTreeTableView != nil) {
                self.mainTreeTableView.reloadData()
            }
        }
    }
    
    func baseCellIsExpandAt(_ indexPath: IndexPath) -> Bool {
        if let currObj = self.dataExpandRow[indexPath.row] as? [Int: AnyObject] {
            if let valueExpand = currObj[-1] as? NSNumber {
                return valueExpand.boolValue
            }
        }
        return true
    }
    
    func subBaseCellIsExpandAt(_ baseCellIndexPath: IndexPath, subBaseCellIndexPath: IndexPath) -> Bool {
        if let currObj = self.dataExpandRow[baseCellIndexPath.row] as? [Int: AnyObject] {
            if let valueExpand = currObj[subBaseCellIndexPath.row] as? NSNumber {
                return valueExpand.boolValue
            }
        }
        return true
    }
}

extension EzyTreeView : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.treeViewDataSource != nil) {
            return self.treeViewDataSource.treeViewNumberOfBaseRow()
        } else {
//            fatalError("TreeViewDataSource must not nil")
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.treeViewDataSource != nil) {
            let hasChild = self.treeViewDataSource.treeViewBaseCellHasChild(baseCellIndexPath: indexPath)
            if (hasChild) {
                self.treeCell.currIndexPath = indexPath
                let heightCell = self.treeCell.getHeithOfCell()
                return heightCell
            }
            
            return self.treeViewDataSource.treeViewHeightForDetailRow()
        } else {
            fatalError("TreeViewDataSource must not nil")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BaseTreeTableViewCell!
        if indexPath.row >= 0 {
            let dataCell = self.treeViewDataSource.treeViewDataBaseCell(baseCellIndexPath: indexPath)
            let hasChild = self.treeViewDataSource.treeViewBaseCellHasChild(baseCellIndexPath: indexPath)
            if (hasChild) {
                cell = tableView.dequeueReusableCell(withIdentifier: "TreeTableViewCell") as! TreeTableViewCell
                (cell as! TreeTableViewCell).delegate = self
                (cell as! TreeTableViewCell).treeProtocol = self
                self.updateFontAndColorForCell(cell)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "ChildTreeTableViewCell") as! ChildTreeTableViewCell
                
                self.updateFontAndColorForCell(cell)
            }
            cell.treeViewDataSource = self.treeViewDataSource
            cell.currIndexPath = indexPath
            cell.updateDataForCell(dataCell.name, image: dataCell.image, money: dataCell.money)
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width * 2.0,
                                               bottom: 0, right: 0)
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: "unknowCell")
    }
    
    fileprivate func updateFontAndColorForCell(_ cell: BaseTreeTableViewCell) {
        if let currCell = cell as? TreeTableViewCell {
            currCell.baseVerticalLineColor = self.baseVerticalLineColor
            currCell.subBaseVerticalLineColor = self.subBaseVerticalLineColor
            currCell.mainTitleRootFont = self.mainTitleRootFont
            currCell.mainTitleRootColor = self.mainTitleRootColor
            currCell.mainValueRootFont = self.mainValueRootFont
            currCell.mainValueRootColor = self.mainValueRootColor
            currCell.mainTitleSubRootFont = self.mainTitleSubRootFont
            currCell.mainTitleSubRootColor = self.mainTitleSubRootColor
            currCell.mainValueSubRootFont = self.mainValueSubRootFont
            currCell.mainValueSubRootColor = self.mainValueSubRootColor
            currCell.mainTitleDetailFont = self.mainTitleDetailFont
            currCell.mainTitleDetailColor = self.mainTitleDetailColor
            currCell.mainValueDetailFont = self.mainValueDetailFont
            currCell.mainValueDetailColor = self.mainValueDetailColor
        } else if let currCell = cell as? ChildTreeTableViewCell {
            currCell.mainTitleDetailFont = self.mainTitleDetailFont
            currCell.mainTitleDetailColor = self.mainTitleDetailColor
            currCell.mainValueDetailFont = self.mainValueDetailFont
            currCell.mainValueDetailColor = self.mainValueDetailColor
        }
    }
}

extension EzyTreeView : TreeTableViewCellDelegate {
    func treeCellDidSelectExpand(_ treeCell: TreeTableViewCell) {
        let baseCellIndexPath = self.mainTreeTableView.indexPath(for: treeCell)
        if (baseCellIndexPath != nil) {
            var isExpand = true
            if var currObj = self.dataExpandRow[baseCellIndexPath!.row] as? [Int: AnyObject] {
                if let valueExpand = currObj[-1] as? NSNumber {
                    isExpand = valueExpand.boolValue
                }
                currObj[-1] = NSNumber(value: !isExpand)
                self.dataExpandRow[baseCellIndexPath!.row] = currObj as AnyObject
            } else {
                let currObj: [Int: AnyObject] = [-1 : NSNumber(value: !isExpand)]
                self.dataExpandRow[baseCellIndexPath!.row] = currObj as AnyObject
            }
        }
        
        self.reloadTreeView()
    }
    
    func treeCell(_ treeCell: TreeTableViewCell, indexPathChildExpand: IndexPath) {
        let baseCellIndexPath = self.mainTreeTableView.indexPath(for: treeCell)
        if (baseCellIndexPath != nil) {
            var isExpand = true
            if var currObj = self.dataExpandRow[baseCellIndexPath!.row] as? [Int: AnyObject] {
                if let valueExpand = currObj[indexPathChildExpand.row] as? NSNumber {
                    isExpand = valueExpand.boolValue
                }
                currObj[indexPathChildExpand.row] = NSNumber(value: !isExpand)
                self.dataExpandRow[baseCellIndexPath!.row] = currObj as AnyObject
            } else {
                let currObj: [Int: AnyObject] = [indexPathChildExpand.row : NSNumber(value: !isExpand)]
                self.dataExpandRow[baseCellIndexPath!.row] = currObj as AnyObject
            }
        }
        
        self.reloadTreeView()
    }
}
