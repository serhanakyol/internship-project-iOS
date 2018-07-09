//
//  AddCompaniesVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 28.05.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class AddCompaniesVC: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    
    var nameS: String?
    var emailS: String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameS = name.text
        emailS = email.text
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func addButton(_ sender: Any) {
        
        
        let url = "http://bitirme.emre.pw/Firma/Ekle"
        loadURL(url: url)
        
        
    }
    
    
    @objc func loadURL(url:String){
        
        nameS = name.text
        emailS = email.text
        
        
        if nameS != "" && emailS != "" {
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
        
        
        let params: Parameters = [
            "token": retrieveToken,
            "adi": nameS!,
            "eposta": emailS!
        ]
        
        print(params)
        
        
        
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
                        
                        let alert = UIAlertController(title: "Eklendi", message: "Firma başarıyla eklendi", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.name.text = ""
                        self.email.text = ""
                        
                    }
                    
                }
                
                
      
            }
                
                
        }
       
    }
    
    
    
    
}
