
//
//  ChangeResultVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 26.06.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class ChangeResultVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet weak var textField: UITextField!
    
    let status = ["Stajı Reddet", "Stajı Onayla"]
    var pickerView = UIPickerView()
    
    
    var delegate:InternshipList?
    var getStaj_id = String()
    var sequence:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(UIColor.init(red: 0/255, green: 121/255, blue: 107/255, alpha: 1), forKeyPath: "textColor")
        pickerView.backgroundColor = UIColor.white
        textField.inputView = pickerView
        textField.textAlignment = .center
       

      
    }

    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return status.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return status[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        sequence = row
        
        textField.text = status[row]
        textField.resignFirstResponder()
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popViewController(animated: true);
    }
    
    
    
    
    @IBAction func changeButton(_ sender: Any) {
   
       
        if textField.text != "" {
            
            var sendSequence = sequence!
            
            if sequence == 0 {
                sendSequence = -1
            }
            if sequence == 1 {
                sendSequence = 1
            }
 
            
            
            
            
            loadURL(sonuc: sendSequence)
        }
        
        
        
        
    }
    
 
    
 
    
    //loadURL
    
    @objc func loadURL(sonuc: Int){
        
        
        let url = "http://bitirme.emre.pw/Staj/SonucDegistir"
        
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
        
        
        let params: Parameters = [
            "token": retrieveToken,
            "staj_id": getStaj_id,
            "sonuc": sonuc
        ]
        
        
        
        //        print(params)
        let path = URL(string:url)
        
        
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                
                
                let result = response.result
                print(response)
       
        }
        
    
    }
    //end loadURL

    
    

}
