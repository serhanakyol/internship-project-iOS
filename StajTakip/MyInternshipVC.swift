//
//  DaysVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 8.05.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class MyInternshipVC: UIViewController, UITableViewDelegate, UITableViewDataSource {    
    @IBOutlet weak var tableView: UITableView!
    
    var adet = 0
    var adet1:Int = 0
    var jsonTitle = [String]()
    var jsonFirstDate = [String]()
    var jsonLastDate = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "http://bitirme.emre.pw/Staj/Listele"
        loadURL(url: url)
        
    }

    
    
    
    func loadURL(url:String){
        
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
        
        
        let params: Parameters = [
            "token": retrieveToken,
            "kullanici_id": retrieveId
        ]
        
        
        
        //        print(params)
        let path = URL(string:url)
        
        
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                
                
                let result = response.result
                
                
                
                
                //print(response)
                
                
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let key = dict["stajlarim"] as? [Dictionary<String,AnyObject>]{
                        

                        self.adet1 = key.count

                        print(self.adet1)
                
                        for i in 0..<key.count{
                            
                            
                            if let id = key[i]["id"] as? String{
                                

                               self.jsonTitle.append(id)

                                self.tableView.reloadData()
                                
                            }
                            if let bitis_tarih = key[i]["bitis_tarih"] as? String{
                                
                                
                                self.jsonLastDate.append(bitis_tarih)
                                
                                self.tableView.reloadData()
                                
                            }
                            if let baslangic_tarih = key[i]["baslangic_tarih"] as? String{
                                
                                
                                self.jsonFirstDate.append(baslangic_tarih)
                                
                                self.tableView.reloadData()
                                
                            }
                            
                            
                            
                            
                         
                        }
                    }
                }
                
                
                
        }
        self.tableView.reloadData()
    }
    
    
    //son
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return self.adet1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyInternshipTVCell
        

        cell.name.text = jsonTitle[indexPath.row]
        cell.firstDate.text = "String(jsonFirstDate[indexPath.row])"
        cell.lastDate.text = "String(jsonLastDate[indexPath.row])"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "daysdetails", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "daysdetails" {
            let newVC = segue.destination as! DaysDetailsVC
            newVC.delegate = self
            
            
            
        }
    }

}
