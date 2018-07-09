//
//  InternshipVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 9.05.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class InternshipVC: UIViewController {

    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var finishDateTextField: UITextField!
    @IBOutlet weak var companiesButton: UIButton!
    
    @IBOutlet weak var firma: UILabel!
    var delegate:CompaniesDetailsVC?
    let picker = UIDatePicker()
    var firma_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        picker.setValue(UIColor.init(red: 0/255, green: 121/255, blue: 107/255, alpha: 1), forKeyPath: "textColor")
        picker.backgroundColor = UIColor.white
        
        
        
        picker.datePickerMode = UIDatePickerMode.date
        
 
        
        startDateTextField.addTarget(self, action: #selector(createDatePickerStart), for: UIControlEvents.touchDown)
        finishDateTextField.addTarget(self, action: #selector(createDatePickerFinish), for: UIControlEvents.touchDown)
    }

 
    
    @objc func createDatePickerStart(tf: UITextField) {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(title: "Devam", style: .plain, target: nil, action: #selector(donePressedStart))
        done.tintColor = UIColor.init(red: 0/255, green: 121/255, blue: 107/255, alpha: 1)
        
        toolbar.setItems([done], animated: false)
        
        tf.inputAccessoryView = toolbar
        tf.inputView = picker
        
        
        // format picker for date
        
        self.picker.locale = Locale(identifier: "TR")
        picker.datePickerMode = .date
    }
    
    
    @objc func donePressedStart() {
        // format date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
 
     
        let dateString = formatter.string(from: picker.date)
        
     
        

        startDateTextField.text = "\(dateString)"
        self.view.endEditing(true)
    }

    
    @objc func createDatePickerFinish(tf: UITextField) {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(title: "Devam", style: .plain, target: nil, action: #selector(donePressedFinish))
        done.tintColor = UIColor.init(red: 0/255, green: 121/255, blue: 107/255, alpha: 1)
        
        toolbar.setItems([done], animated: false)
        
        tf.inputAccessoryView = toolbar
        tf.inputView = picker
        
        
        // format picker for date
        
        self.picker.locale = Locale(identifier: "TR")
        picker.datePickerMode = .date
    }
    
    
    @objc func donePressedFinish() {
        // format date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: picker.date)
        
        finishDateTextField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        if startDateTextField!.text != "" && finishDateTextField!.text != "" {
            
            
            
            var retrieveToken = UserDefaults.standard.string(forKey: "token")!
            var retrieveId = UserDefaults.standard.string(forKey: "id")!
            
            
            
            let params: Parameters = [
                "token": retrieveToken,
                "baslangic_tarih": startDateTextField.text!,
                "bitis_tarih": finishDateTextField.text!,
                "firma_id": firma_id,
                "kullanici_id": retrieveId,
                "bolum_id": 1
                
            ]
            print(params)
            
            
            
            //        print(params)
            
            let url = "http://bitirme.emre.pw/Staj/Ekle"
            
            let path = URL(string:url)
            
            
            Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
                .responseJSON { response in
                    
                    
                    
                    
                    
                    
                   
                    
                    
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        let successResult = JSON.object(forKey: "result")!
                    
                        var successInt = successResult as! Int
                        if successInt == 1 {
                         
                            let alert = UIAlertController(title: "Eklendi", message: "Staj talebiniz başarıyla eklendi", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.startDateTextField!.text = ""
                            self.finishDateTextField!.text = ""
                            self.companiesButton.setTitle("Seçiniz", for: .normal)
                        }
                        
                    }
                    
                    
                 
                  
                        
                  
              
                
                    }
                    
                    
                    
            }
            
            
            
            
            
        }//if
        
    }//buton
    


