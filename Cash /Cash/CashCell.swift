//
//  CashCell.swift
//  Cash
//
//  Created by Bioo on 05.11.2020.
//

import UIKit

class CashCell: UITableViewCell {

    @IBOutlet var summLabel: UILabel!
    @IBOutlet var commLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
