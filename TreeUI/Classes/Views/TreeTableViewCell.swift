//
//  TreeTableViewCell.swift
//  TreeUI
//
//  Created by TamNguyen on 9/19/16.
//  Copyright © 2016 TamNguyen. All rights reserved.
//

import UIKit

protocol TreeTableViewCellDelegate {
    func treeCellDidSelectExpand(_ treeCell: TreeTableViewCell)
    func treeCell(_ treeCell: TreeTableViewCell, indexPathChildExpand: IndexPath)
}

class TreeTableViewCell: BaseTreeTableViewCell {
    
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
    // Font for title label root cell
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
    
    public var delegate: TreeTableViewCellDelegate!
    public var treeProtocol: EzyTreeView! {
        didSet {
            if (self.subTreeCell != nil) {
                self.subTreeCell.treeProtocol = self.treeProtocol
            }
        }
    }

    @IBOutlet weak fileprivate var expandButton: UIButton!
    @IBOutlet weak fileprivate var subTreeTableView: UITableView!
    fileprivate var subTreeCell: SubTreeTableViewCell!
    @IBOutlet weak fileprivate var verticalLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subTreeTableView.clipsToBounds = true
        self.subTreeTableView.tableFooterView = UIView()
        self.subTreeTableView.register(UINib(nibName: "SubTreeTableViewCell", bundle: nil),
                                           forCellReuseIdentifier: "SubTreeTableViewCell")
        
        self.subTreeTableView.register(UINib(nibName: "ChildTreeTableViewCell", bundle: nil),
                                           forCellReuseIdentifier: "ChildTreeTableViewCell")
        
        let cellnib = Bundle.main.loadNibNamed("SubTreeTableViewCell", owner:nil, options: nil)
        print(cellnib)
        if ((cellnib?.count)! > 0) {
            subTreeCell = cellnib?.first as! SubTreeTableViewCell
            subTreeCell.treeViewDataSource = self.treeViewDataSource
            self.subTreeCell.treeProtocol = self.treeProtocol
        } else {
            fatalError("Can't load SubTreeTableViewCell")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getHeithOfCell() -> CGFloat {
        if (self.treeViewDataSource != nil) {
            var heightCell: CGFloat = self.treeViewDataSource.treeViewHeightForDetailRow()
            
            let numberRow = self.treeViewDataSource.treeViewNumberOfSubBaseCell(baseCellIndexPath: self.currIndexPath)
            
            for index in 0..<numberRow {
                let indexPath = IndexPath(row: index, section: 0)
                self.subTreeCell.parentCellIndexPath = self.currIndexPath
                self.subTreeCell.currIndexPath = indexPath
                
                heightCell += self.subTreeCell.getHeithOfCell()
            }
            
            let isExpand = self.treeProtocol.baseCellIsExpandAt(self.currIndexPath)
            if (isExpand == false) {
                heightCell = self.treeViewDataSource.treeViewHeightForDetailRow()
            }
            
            return heightCell
        } else {
            fatalError("TreeViewDataSource must not nil")
        }
    }
    @IBAction func expandButtonPressed(_ sender: AnyObject) {
        if (self.delegate != nil) {
            self.delegate.treeCellDidSelectExpand(self)
        }
    }
    
    override func updateDataForCell(_ name: String, image: String, money: CGFloat) {
        super.updateDataForCell(name, image: image, money: money)
        
        // Update font and color
        self.nameLabel.font = self.mainTitleRootFont
        self.nameLabel.textColor = self.mainTitleRootColor
        
        self.moneyLabel.font = self.mainValueRootFont
        self.moneyLabel.textColor = self.mainValueRootColor
        
        self.verticalLineView.backgroundColor = self.baseVerticalLineColor
        
        // Show UI childs
        let hasChild = self.treeViewDataSource.treeViewBaseCellHasChild(baseCellIndexPath: self.currIndexPath)
        if (hasChild) {
            self.subTreeTableView.reloadData()
            self.subTreeTableView.isHidden = false
        } else {
            self.subTreeTableView.isHidden = true
        }
    }
    
    override func didSetTreeViewDataSource() {
        self.subTreeCell.treeViewDataSource = self.treeViewDataSource
    }
}

extension TreeTableViewCell : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.treeViewDataSource != nil) {
            let numberRow = self.treeViewDataSource.treeViewNumberOfSubBaseCell(baseCellIndexPath: self.currIndexPath)
            return numberRow
        } else {
//            fatalError("TreeViewDataSource must not nil")
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.treeViewDataSource != nil) {
            let hasChild = self.treeViewDataSource.treeViewSubBaseCellHasChild(baseCellIndexPath: self.currIndexPath,
                                                                               subBaseIndexPath: indexPath)
            if (hasChild) {
                self.subTreeCell.currIndexPath = indexPath
                self.subTreeCell.parentCellIndexPath = self.currIndexPath
                
                let heightCell = self.subTreeCell.getHeithOfCell()
                return heightCell
            }
            
            return self.treeViewDataSource.treeViewHeightForDetailRow()
        } else {
            fatalError("TreeViewDataSource must not nil")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BaseTreeTableViewCell!
        
        if (indexPath.row >= 0 && self.treeViewDataSource != nil) {
            let dataCell = self.treeViewDataSource.treeViewDataSubBaseCell(baseCellIndexPath: self.currIndexPath, subBaseIndexPath: indexPath)
            let hasChild = self.treeViewDataSource.treeViewSubBaseCellHasChild(baseCellIndexPath: self.currIndexPath, subBaseIndexPath: indexPath)
            
            if (hasChild) {
                cell = tableView.dequeueReusableCell(withIdentifier: "SubTreeTableViewCell") as! SubTreeTableViewCell
                (cell as! SubTreeTableViewCell).parentCellIndexPath = self.currIndexPath
                (cell as! SubTreeTableViewCell).delegate = self
                self.updateFontAndColorForCell(cell)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "ChildTreeTableViewCell") as! ChildTreeTableViewCell
                
                self.updateFontAndColorForCell(cell)
            }
            cell.treeViewDataSource = self.treeViewDataSource
            cell.currIndexPath = indexPath
            
            cell.updateDataForCell(dataCell.name, image: dataCell.image, money: dataCell.money)
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "unknowCell")
    }
    
    fileprivate func updateFontAndColorForCell(_ cell: BaseTreeTableViewCell) {
        if let currCell = cell as? SubTreeTableViewCell {
            currCell.subBaseVerticalLineColor = self.subBaseVerticalLineColor
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

extension TreeTableViewCell : SubTreeTableViewCellDelegate {
    func subTreeCellDidSelectExpand(_ subTreeCell: SubTreeTableViewCell) {
        if (self.delegate != nil) {
            let indexPath = self.subTreeTableView.indexPath(for: subTreeCell)
            if (indexPath != nil) {
                self.delegate.treeCell(self,
                                       indexPathChildExpand: indexPath!)
            }
        }
    }
}
