//
//  DayOrgDetailVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 2.06.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class DayOrgDetailVC: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailText: UITextView!
    
    var delegate1:DayVC?
    var tarih = String()
    var aciklama = String()
    var stajId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = tarih
        detailText.text = aciklama
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func saveButton(_ sender: Any) {
        let url = "http://bitirme.emre.pw/Staj/RaporDuzenle"
        loadURL(url: url)
    }
    
    //loadURL
    
    func loadURL(url:String){
        
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
   
        
        
        
  
        let params: Parameters = [
            "token": retrieveToken,
            "kullanici_id": retrieveId,
            "rapor_id": stajId,
            "aciklama": detailText.text!
        ]
        
        print(params)
        
        
        //        print(params)
        let path = URL(string:url)
        
        
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                
                
                let result = response.result
                print(response)
          
        }
      
    }
    //loadUrl end
    
    

}
