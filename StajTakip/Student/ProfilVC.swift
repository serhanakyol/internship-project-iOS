//
//  ProfilVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 8.05.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit

class ProfilVC: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var school: UILabel!
    
    @IBOutlet weak var studentPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = UserDefaults.standard.string(forKey: "ad_soyad")!
        email.text = UserDefaults.standard.string(forKey: "eposta")!
        number.text = UserDefaults.standard.string(forKey: "ogrenci_no")!
        school.text = UserDefaults.standard.string(forKey: "bolum")!
        
        var resimUrl = NSURL(string: UserDefaults.standard.string(forKey: "resim")! as! String)
        var resimData = NSData(contentsOf: resimUrl! as URL)
        
        studentPhoto.image = UIImage(data: resimData as! Data)
        
        
        photoCircle(photo: studentPhoto)
    }

    @IBAction func editTapped(_ sender: Any) {
           performSegue(withIdentifier: "goEdit", sender: nil)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goEdit" {
            let newVC = segue.destination as! EditProfilVC
            newVC.delegate = self

            
        }
    }
    func photoCircle(photo:UIImageView){
  
        photo.layer.masksToBounds = false
        photo.layer.cornerRadius = studentPhoto.frame.height/2
        photo.clipsToBounds = true
        
        
    }

}
