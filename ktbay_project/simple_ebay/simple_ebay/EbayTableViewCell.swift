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
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
