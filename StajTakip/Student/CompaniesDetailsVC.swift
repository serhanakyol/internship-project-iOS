//
//  CompaniesDetailsVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 12.05.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit

class CompaniesDetailsVC: UIViewController {

    @IBOutlet weak var nameDetail: UILabel!
    
    var getAdi = String()
    var getid = String()
    var delegate:CompaniesVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameDetail.text = getAdi

       
    }

    @IBAction func confirmationTapped(_ sender: Any) {
        
        
        let go = self.navigationController?.viewControllers.first as! InternshipVC
       
        go.companiesButton.setTitle(getAdi, for: .normal)
        go.firma_id = getid
        navigationController?.popToRootViewController(animated: true)
        
        
        
    }
    
  
    
    
 
    }
    



