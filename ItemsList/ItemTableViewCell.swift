//
//  ItemTableViewCell.swift
//  ItemsList
//
//  Created by bogdan.cernea on 07/05/2020.
//  Copyright © 2020 bogdan.cernea. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    var item: Item? {
        didSet {
            self.textLabel?.text = self.item?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
