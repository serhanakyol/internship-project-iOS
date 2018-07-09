//
//  AddStaffVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 21.06.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class AddStaffVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    
    var emailString: String?
    var passString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        emailString = email.text
        passString = pass.text
        
    }

    @IBAction func addTapped(_ sender: Any) {
        
        let url = "http://bitirme.emre.pw/Firma/PersonelEkle"
        loadURL(url: url)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    func loadURL(url:String){
        
        emailString = email.text
        passString = pass.text
        
        
        if emailString != "" && passString != "" {
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
        
        
        let params: Parameters = [
            "token": retrieveToken,
            "firma_id": retrieveId,
            "eposta": emailString!,
            "sifre": passString!
        ]
        
        print(params)
        
        
        
        //        print(params)
        let path = URL(string:url)
        
        
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                
                
   
                print(response)
                
             
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    let successResult = JSON.object(forKey: "result")!
                    
                    var successInt = successResult as! Int
                    if successInt == 1 {
                        
                        let alert = UIAlertController(title: "Eklendi", message: "Personel başarıyla eklendi", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.email!.text = ""
                        self.pass!.text = ""
                   

                    }
                    
                }

                
                
        }
        
        }
    }
    

}
