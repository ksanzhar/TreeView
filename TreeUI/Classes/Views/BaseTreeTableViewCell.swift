//
//  BaseTreeTableViewCell.swift
//  TreeUI
//
//  Created by TamNguyen on 9/23/16.
//  Copyright © 2016 TamNguyen. All rights reserved.
//

import UIKit
import AlamofireImage

class BaseTreeTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    public var parentCellIndexPath: IndexPath!
    public var currIndexPath: IndexPath!
    public var treeViewDataSource: EzyTreeViewDataSource! {
        didSet {
            self.didSetTreeViewDataSource()
        }
    }
    
    @IBOutlet weak var baseTopViewConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateDataForCell(_ name: String, image: String, money: CGFloat) {
        DispatchQueue.main.async {
            var width = self.avatarImageview.frame.width
            if (self.treeViewDataSource != nil) {
                if (self.baseTopViewConstraint != nil) {
                    self.baseTopViewConstraint.constant = self.treeViewDataSource.treeViewHeightForDetailRow()
                    width = self.baseTopViewConstraint.constant * 0.875
                }
            }
            
            self.avatarImageview.layer.cornerRadius = width/2.0
            self.avatarImageview.layer.borderWidth = 1.0
            self.avatarImageview.layer.borderColor = UIColor.clear.cgColor
            self.avatarImageview.layer.masksToBounds = true
            
            self.nameLabel.text = name
            self.moneyLabel.text = "\(money)"
            let url = URL(string: image)
            if (url != nil) {
                self.avatarImageview.af_setImage(withURL: URL(string: image)!)
            }
        }
    }
    
    func didSetTreeViewDataSource() {
        
    }
}
