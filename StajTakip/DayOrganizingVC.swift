//
//  DayOrganizingVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 1.06.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit

class DayOrganizingVC: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailText: UITextView!
    
    
      var delegate:DayVC?
//    var tarih = String()
//    var stajId = String()
//    var aciklama = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        dateLabel.text = tarih
//        detailText.text! = aciklama
    }

    @IBAction func saveTapped(_ sender: Any) {
    }
    
    

}
