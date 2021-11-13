//
//  ExpenseCell.swift
//  Spenderr
//
//  Created by Usman Siddiqui on 29/09/2021.
//

import UIKit

class ExpenseCell: UITableViewCell {
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.masksToBounds = true
        iconView.layer.cornerRadius = 9
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
