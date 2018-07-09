//
//  RemoveStaffVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 26.06.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class RemoveStaffVC: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    
    var getid = String()
    var getEmail = String()
    var delegate:StaffVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        emailLabel.text = getEmail
    }

    
    @IBAction func removeButton(_ sender: Any) {
        
        loadURL()
    }
    
    
    
    
    @objc func loadURL(){
        
        
        let url = "http://bitirme.emre.pw/Firma/PersonelSil"
        
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
        
        
        let params: Parameters = [
            "token": retrieveToken,
            "firma_id": retrieveId,
            "personel_id": getid
        ]
        
        
        
        //        print(params)
        let path = URL(string:url)
        
        
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                
                
                let result = response.result
                print(response)
                
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    let successResult = JSON.object(forKey: "result")!
                    
                    var successInt = successResult as! Int
                    if successInt == 1 {
                        
                        let alert = UIAlertController(title: "Silindi", message: "Personel başarıyla silindi", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                      
                        
                    }
                    
                }
                
        }
        
     navigationController?.popToRootViewController(animated: true)
        
    }
    //end loadURL
    
}
