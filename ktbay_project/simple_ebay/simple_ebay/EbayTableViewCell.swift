//
//  EbayTableViewCell.swift
//  simple_ebay
//
//  Created by Katie Barnwell on 1/24/17.
//  Copyright © 2017 kt. All rights reserved.
//

import UIKit

class EbayTableViewCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
