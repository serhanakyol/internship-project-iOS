//
//  LoginStaffVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 29.06.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class LoginStaffVC: UIViewController {

    
    @IBOutlet weak var emailLoginText: UITextField!
    @IBOutlet weak var passLoginText: UITextField!
    
    var idG:String = ""
    var rutbeG:String = ""
    var nameG:String = ""
    var emailG:String = ""
    
    var tokenResult:String = ""
    var firma_idResult:String = ""
    var ad_soyadResult:String = ""
    var idResult:String = ""
    var adiResult:String = ""
    var sifreResult:String = ""
    var epostaResult:String = ""
    var resimResult:String = ""
    var jsonPhoto = [NSData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedLogin(_ sender: Any) {
        
        
        
        
        
        let email:String! = emailLoginText?.text
        let pass:String! = passLoginText?.text
        
        
        if(email.isEmpty || pass.isEmpty){
            
            let alertController = UIAlertController(title: "Boş Alan", message: "Giriş bilgileri boş bırakılamaz!", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: {(action) -> Void in
                //The (withIdentifier: "VC2") is the Storyboard Segue identifier.
                
            })
            
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            
            
            let url = "http://bitirme.emre.pw/Login"
            loadURL(url: url, email: email, pass: pass)
            
            
        }
        
        
    }
    
    
    func loadURL(url:String, email:String, pass:String){
        
        
        
        let params: Parameters = [
            "eposta": email,
            "sifre": pass
        ]
        
        
        let path = URL(string:url)
        
        
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    // print(response.result.value)
                    
                    if let status = response.response?.statusCode {
                        switch(status){
                        case 200:
                            print("Result Success")
                        default:
                            print("Error with response status: \(status)")
                        }
                    }
                    let result = response.result
                    
                    
                    
                    print(result)
                    
                    
                    if let dict = result.value as? Dictionary<String,AnyObject>{
                        print(dict)
                        if let informationKey = dict["bilgiler"] as?  Dictionary<String,AnyObject>{
                            
                            
                            
                            if let token = informationKey["token"] as? String{
                                
                                print(token)
                                self.tokenResult = token
                            }
                             if let rutbe = informationKey["rutbe"] as? String{
                                
                                print(rutbe)
                                self.rutbeG = rutbe
                            }
                            if let id = informationKey["id"] as? String{
                                
                                print(id)
                                self.idResult = id
                            }
                            if let sifre = informationKey["sifre"] as? String{
                                
                                print(sifre)
                                self.sifreResult = sifre
                            }
                            if let eposta = informationKey["eposta"] as? String{
                                
                                print(eposta)
                                self.epostaResult = eposta
                            }
                            if let resim = informationKey["resim"] as? String{
                                
                                self.resimResult = resim
              
                                
                            }
                            if let ad_soyad = informationKey["ad_soyad"] as? String{
                                
                                self.ad_soyadResult = ad_soyad
                                
                                
                            }

                            
                                if let key1 = informationKey["firmalar"] as? [Dictionary<String,AnyObject>]{
                                    
                                    
                                    for i in 0..<key1.count{
                                        
                                        
                                        if let firma_id = key1[i]["firma_id"] as? String{
                                            
                                            print(firma_id)
                                            self.firma_idResult = firma_id
                                           
                                            
                                        }
                                        if let adi = key1[i]["adi"] as? String{
                                            
                                            print(adi)
                                            self.adiResult = adi
                                            
                                            
                                        }
                                        
                                    }
                                }
                            
                    
                        }
                        
                        UserDefaults.standard.set(self.tokenResult, forKey: "token")
                        UserDefaults.standard.set(self.firma_idResult, forKey: "id")
                        UserDefaults.standard.set(self.idResult, forKey: "idUpdate")
                        UserDefaults.standard.set(self.adiResult, forKey: "adi")
                        UserDefaults.standard.set(self.sifreResult, forKey: "sifre")
                        UserDefaults.standard.set(self.epostaResult, forKey: "eposta")
                        UserDefaults.standard.set(self.resimResult, forKey: "resim")
                        UserDefaults.standard.set(self.ad_soyadResult, forKey: "adSoyad")
                        if self.rutbeG == "2" {
                            self.performSegue(withIdentifier: "loginGo2", sender: self)
                        }
                        if self.rutbeG == "3" {
                            self.performSegue(withIdentifier: "loginGo3", sender: self)
                        }
                        
                    }
                        
                        
                        
                        
                        
                    else {
                        print("Error") // Was not a string
                    }
                    
                    
                case .failure(let error):
                    print(error)
                    
                    
                    
                }
                
        }
        
        
        
        
    }
    
    
    
    
    
}
