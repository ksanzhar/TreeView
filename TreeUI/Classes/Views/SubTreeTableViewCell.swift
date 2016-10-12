//
//  TreeTableViewCell.swift
//  TreeUI
//
//  Created by TamNguyen on 9/19/16.
//  Copyright © 2016 TamNguyen. All rights reserved.
//

import UIKit

protocol SubTreeTableViewCellDelegate {
    func subTreeCellDidSelectExpand(_ subTreeCell: SubTreeTableViewCell)
}

class SubTreeTableViewCell: BaseTreeTableViewCell {
    
    // Color vertical line sub cell
    var subBaseVerticalLineColor: UIColor = Utils.hexStringToUIColor("#4f4f4f")
    
    // MARK: Font and Color for Sub Root Cell
    // Font for title label root cell
    var mainTitleSubRootFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    // Color for title label root cell
    var mainTitleSubRootColor: UIColor = Utils.hexStringToUIColor("#444444")
    // Font for value label root cell
    var mainValueSubRootFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    // Color for value label root cell
    var mainValueSubRootColor: UIColor = Utils.hexStringToUIColor("#45a3c2")
    
    // MARK: Font and Color for Detail Cell
    // Font for title label root cell
    var mainTitleDetailFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    // Color for title label root cell
    var mainTitleDetailColor: UIColor = Utils.hexStringToUIColor("#444444")
    // Font for value label root cell
    var mainValueDetailFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    // Color for value label root cell
    var mainValueDetailColor: UIColor = Utils.hexStringToUIColor("#45a3c2")

    @IBOutlet weak fileprivate var expandButton: UIButton!
    @IBOutlet weak fileprivate var subTreeTableView: UITableView!
    @IBOutlet weak fileprivate var verticalLineView: UIView!
    
    public var delegate: SubTreeTableViewCellDelegate!
    public var treeProtocol: EzyTreeView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.subTreeTableView.clipsToBounds = true
        self.subTreeTableView.tableFooterView = UIView()
        self.subTreeTableView.register(UINib(nibName: "ChildTreeTableViewCell", bundle: nil),
                                           forCellReuseIdentifier: "ChildTreeTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getHeithOfCell() -> CGFloat {
        if (self.treeViewDataSource != nil) {
            let heightDetail = self.treeViewDataSource.treeViewHeightForDetailRow()
            var heightCell: CGFloat = heightDetail
            
            let numberRow = self.treeViewDataSource.treeViewNumberOfDetailCell(baseCellIndexPath: self.parentCellIndexPath, subBaseIndexPath: self.currIndexPath)
            heightCell += CGFloat(numberRow) * heightDetail
            
            let isExpand = self.treeProtocol.subBaseCellIsExpandAt(self.parentCellIndexPath, subBaseCellIndexPath: self.currIndexPath)
            if (isExpand == false) {
                heightCell = heightDetail
            }
            
            return heightCell
        } else {
            fatalError("TreeViewDataSource must not nil")
        }
    }
    
    override func updateDataForCell(_ name: String, image: String, money: CGFloat) {
        super.updateDataForCell(name, image: image, money: money)
        
        // Update Font and Color
        self.nameLabel.font = self.mainTitleSubRootFont
        self.nameLabel.textColor = self.mainTitleSubRootColor
        
        self.moneyLabel.font = self.mainValueSubRootFont
        self.moneyLabel.textColor = self.mainValueSubRootColor
        
        self.verticalLineView.backgroundColor = self.subBaseVerticalLineColor
        
        // Update UI for Child
        if (self.treeViewDataSource != nil) {
            let hasChild = self.treeViewDataSource.treeViewSubBaseCellHasChild(baseCellIndexPath: self.parentCellIndexPath, subBaseIndexPath: self.currIndexPath)
            if (hasChild) {
                self.subTreeTableView.reloadData()
                self.subTreeTableView.isHidden = false
            } else {
                self.subTreeTableView.isHidden = true
            }
        } else {
            fatalError("TreeViewDataSource must not nil")
        }
    }
    @IBAction func expandButtonPressed(_ sender: AnyObject) {
        if (self.delegate != nil) {
            self.delegate.subTreeCellDidSelectExpand(self)
        }
    }
}

extension SubTreeTableViewCell : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.treeViewDataSource != nil) {
            let numberRow = self.treeViewDataSource.treeViewNumberOfDetailCell(baseCellIndexPath: self.parentCellIndexPath, subBaseIndexPath: self.currIndexPath)
            return numberRow
        } else {
//            fatalError("TreeViewDataSource must not nil")
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.treeViewDataSource != nil) {
            return self.treeViewDataSource.treeViewHeightForDetailRow()
        } else {
            fatalError("TreeViewDataSource must not nil")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildTreeTableViewCell") as! ChildTreeTableViewCell
        cell.selectionStyle = .none
        if (self.treeViewDataSource != nil) {
            let dataCell = self.treeViewDataSource.treeViewDataDetailCell(baseCellIndexPath: self.parentCellIndexPath, subBaseIndexPath: self.currIndexPath, detailCellIndexPath: indexPath)
            if (indexPath.row >= 0) {
                self.updateFontAndColorForCell(cell)
                
                cell.updateDataForCell(dataCell.name, image: dataCell.image, money: dataCell.money)
            }
        } else {
            fatalError("TreeViewDataSource must not nil")
        }
        
        return cell
    }
    
    fileprivate func updateFontAndColorForCell(_ cell: BaseTreeTableViewCell) {
        if let currCell = cell as? ChildTreeTableViewCell {
            currCell.mainTitleDetailFont = self.mainTitleDetailFont
            currCell.mainTitleDetailColor = self.mainTitleDetailColor
            currCell.mainValueDetailFont = self.mainValueDetailFont
            currCell.mainValueDetailColor = self.mainValueDetailColor
        }
    }
}
