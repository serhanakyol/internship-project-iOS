//
//  InternshipListTVCell.swift
//  StajTakip
//
//  Created by Serhan Akyol on 26.06.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit

class InternshipListTVCell: UITableViewCell {

    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var firstDate: UILabel!
    @IBOutlet weak var lastDate: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var point2: UILabel!
    @IBOutlet weak var point3: UILabel!
    @IBOutlet weak var point4: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
