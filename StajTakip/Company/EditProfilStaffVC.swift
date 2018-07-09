//
//  EditProfilStaffVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 7.07.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class EditProfilStaffVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {


    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var photoSelect: UIImageView!
    
    var getAdi = String()
    var getid = String()
    var getSifre = String()
    var delegate:ProfilStaffVC?
    
    var getPhoto: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoSelect.isUserInteractionEnabled = true //fotoğrafa tıklanma izini
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfilStaffVC.selectImage)) //tıklanınca gideceği fonk
        photoSelect.addGestureRecognizer(gestureRecognizer)
        
        nameText.text = UserDefaults.standard.string(forKey: "adSoyad")!
        passText.text = UserDefaults.standard.string(forKey: "sifre")!
        
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //select photo
    @objc func selectImage(){ //picker ile galeriden fotoğrafı seçme izinini verildi
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //fotoğraf seçildikten sonra
        getPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        photoSelect.image = getPhoto
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    //end select photo
    
    @IBAction func saveTapped(_ sender: Any) {
        loadURL()
    }
    
    
    //loadURL
    
    func loadURL(){
        
        
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "idUpdate")!
        
        
        
        if getPhoto != nil {
            
            let url = URL(string: "http://bitirme.emre.pw/Hesap/Duzenle")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
            
            
            let imgData = UIImageJPEGRepresentation(getPhoto!, 0.2)!
            
            
            
            
            
            if nameText.text != "" && passText.text != ""{
                let parameters: Parameters = [
                    "token": retrieveToken,
                    "kullanici_id": retrieveId,
                    "ad_soyad": nameText.text!,
                    "sifre": passText.text!
                ]
                
                print(parameters)
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imgData, withName: "resim",fileName: "resim.jpg", mimeType: "image/jpg")
                    for (key, value) in parameters {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    } //Optional for extra parameters
                },
                                 to:url)
                { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            print("Upload Progress: \(progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            print(response.result.value)
                            let alertController = UIAlertController(title: "Kaydedildi", message: "Düzenleme başarılı.", preferredStyle: UIAlertControllerStyle.alert)
                            let ok = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: {(action) -> Void in
                                
                                
                            })
                            
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                        
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                }
                
                
                
            }
        }
        
    }
    //loadUrl end
    
    
}
