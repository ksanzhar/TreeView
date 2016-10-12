//
//  ChildTreeTableViewCell.swift
//  TreeUI
//
//  Created by TamNguyen on 9/22/16.
//  Copyright © 2016 TamNguyen. All rights reserved.
//

import UIKit

class ChildTreeTableViewCell: BaseTreeTableViewCell {

    // Font for title label detail cell
    var mainTitleDetailFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    // Color for title label detail cell
    var mainTitleDetailColor: UIColor = Utils.hexStringToUIColor("#444444")
    // Font for value label detail cell
    var mainValueDetailFont: UIFont = UIFont(name: "Roboto-Regular", size: 15)!
    // Color for value label detail cell
    var mainValueDetailColor: UIColor = Utils.hexStringToUIColor("#45a3c2")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func updateDataForCell(_ name: String, image: String, money: CGFloat) {
        super.updateDataForCell(name, image: image, money: money)
        
        self.nameLabel.font = self.mainTitleDetailFont
        self.nameLabel.textColor = self.mainTitleDetailColor
        
        self.moneyLabel.font = self.mainValueDetailFont
        self.moneyLabel.textColor = self.mainValueDetailColor
    }
    
    @IBAction func expandButtonPressed(_ sender: AnyObject) {
    }
}
