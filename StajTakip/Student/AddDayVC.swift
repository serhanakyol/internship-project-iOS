//
//  AddDayVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 31.05.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class AddDayVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var calendarTextF: UITextField!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var photoSelect: UIImageView!
    @IBOutlet weak var photoSelectLabel: UILabel!
    
    let picker = UIDatePicker()
    
     var delegate:DayVC?
    var baslangicTarih = String()
    var bitisTarih = String()
    var stajId = String()
    var getPhoto: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        photoSelect.isUserInteractionEnabled = true //fotoğrafa tıklanma izini
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddDayVC.selectImage)) //tıklanınca gideceği fonk
        photoSelect.addGestureRecognizer(gestureRecognizer)
        
        print(baslangicTarih)
        
        let baslangicSplitBosluk = baslangicTarih.components(separatedBy: " ")
        let bitisSplitBosluk = bitisTarih.components(separatedBy: " ")
        
        var basTarih = baslangicSplitBosluk[0]
        var bitTarih = bitisSplitBosluk[0]
        let baslangicSplitTre = basTarih.components(separatedBy: "-")
        let bitisSplitTre = bitTarih.components(separatedBy: "-")
        
        print(baslangicSplitTre[0])
        print(baslangicSplitTre[1])
        print(baslangicSplitTre[2])
        print(bitisSplitTre[0])
        print(bitisSplitTre[1])
        print(bitisSplitTre[2])
        
        picker.setValue(UIColor.init(red: 0/255, green: 121/255, blue: 107/255, alpha: 1), forKeyPath: "textColor")
        picker.backgroundColor = UIColor.white
        
        
        
        picker.datePickerMode = UIDatePickerMode.date
        
                let calendar = Calendar.current
                var minDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
                minDateComponent.day = Int(baslangicSplitTre[2])
                minDateComponent.month = Int(baslangicSplitTre[1])
                minDateComponent.year = Int(baslangicSplitTre[0])
        
                let minDate = calendar.date(from: minDateComponent)
                print(" min date : \(minDate)")
        
                var maxDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
                maxDateComponent.day = Int(bitisSplitTre[2])
                maxDateComponent.month = Int(bitisSplitTre[1])
                maxDateComponent.year = Int(bitisSplitTre[0])
        
                let maxDate = calendar.date(from: maxDateComponent)
                print("max date : \(maxDate)")
        
                self.picker.minimumDate = minDate! as Date
                self.picker.maximumDate =  maxDate! as Date
        
        
        
        calendarTextF.addTarget(self, action: #selector(createDatePickerStart), for: UIControlEvents.touchDown)
        
        

        
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
        self.dismiss(animated: true, completion: nil)
        photoSelectLabel.text = "Seçildi"
        
        
    }
    
    //end select photo
    
    
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
        
        
        
        
        calendarTextF.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        
                loadURL()
    }
    
    
    

    //loadURL

    func loadURL(){
        print("girdi")

        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!


       
        if getPhoto != nil {
            
            let url = URL(string: "http://bitirme.emre.pw/Staj/RaporEkle")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
      

        let imgData = UIImageJPEGRepresentation(getPhoto!, 0.2)!

        print("tarihhh")
      
        let parameters: Parameters = [
            "token": retrieveToken,
            "kullanici_id": retrieveId,
            "tarih": calendarTextF.text!,
            "aciklama": detailText.text!,
            "staj_id": stajId
        ]

            print(parameters)
       
        if calendarTextF.text! != "" {
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "resimler[]",fileName: "resim.jpg", mimeType: "image/jpg")
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
                        let alertController = UIAlertController(title: "Gün Eklendi", message: "Gün ekleme başarılı.", preferredStyle: UIAlertControllerStyle.alert)
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
