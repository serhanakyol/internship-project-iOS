//
//  DaysTVCell.swift
//  StajTakip
//
//  Created by Serhan Akyol on 9.05.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit

class MyInternshipTVCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var firstDate: UILabel!
    @IBOutlet weak var lastDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
