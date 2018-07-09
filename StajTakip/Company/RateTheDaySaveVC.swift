//
//  RateTheDaySaveVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 8.07.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class RateTheDaySaveVC: UIViewController {

    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    
    var delegate:RateTheDayVC?
    var getAddDayArray = [Int]()
    var getStaj_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()


  
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popViewController(animated: true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        print("tıklandı")
        
        if  textField1.text != "" && textField2.text != "" && textField3.text != "" && textField4.text != ""{
            
        
        if Int(textField1.text!)!<6 && Int(textField2.text!)!<6 && Int(textField3.text!)!<6 && Int(textField4.text!)!<6 {
            
            print("girdi")
            var pointString = textField1.text! + textField2.text! + textField3.text! + textField4.text!
            
             let url = "http://bitirme.emre.pw/Firma/StajDegerlendir"
             var retrieveToken = UserDefaults.standard.string(forKey: "token")!
            
            print(getAddDayArray)
            var parca:String = "["
            
            for i in getAddDayArray {
                if i+1 != nil {
                parca += String(i)
                parca += ","
                    
                }
                else {
                    parca += String(i)
                }
                
            }
            var yeniParca = String(parca.dropLast())
            yeniParca += "]"
         
            

          print(yeniParca)
            
             
             let params: Parameters = [
             "token": retrieveToken,
             "raporlar": yeniParca,
             "staj_id": getStaj_id,
             "puan": pointString
             ]
             
             print(params)
             
             let path = URL(string:url)
             
             Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
             .responseJSON { response in
             
             
             let result = response.result
             
             
             
             
             print(response)
             
             let alert = UIAlertController(title: "Başarılı!", message: "Puan verme işlemi başarıyla sonuçlandı.", preferredStyle: UIAlertControllerStyle.alert)
             alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             
                self.textField1.text = ""
                self.textField2.text = ""
                self.textField3.text = ""
                self.textField4.text = ""
       
             
             }
 
            
        }
        else{
            
            let alert = UIAlertController(title: "Hata !", message: "Lütfen en yüksek 5 puan veriniz.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            
            let alert = UIAlertController(title: "Boş alan !", message: "Lütfen boş alan bırakmayınız.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    

    


}
