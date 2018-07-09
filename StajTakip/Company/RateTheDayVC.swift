//
//  RateTheDayVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 29.06.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire
var flag = ""

class RateTheDayVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointText: UITextField!
    
    var delegate:InternshipList?
    var getStaj_id = String()
    
    var aciklamaJSON = [String]()
    var staj_tarihiJSON = [String]()
    var idJSON = [String]()
    
    var addDayArray = [Int]()
   
    var selected:Int?
    var adet:Int = 0
    var checkedCount = 0
    
    var checked = [Bool]()
    var flagCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checked.removeAll()
        
        flag = getStaj_id
        let url = "http://bitirme.emre.pw/Staj/RaporListele"
        loadURL2(url: url)
        
        print("cakalll")
        print(checked)
        
        print("girdiiiii")
        print(getStaj_id)
       
        loadURL(url: url)

        
    }
    

    
    //save tapped
    @IBAction func saveTapped(_ sender: Any) {
        if addDayArray.count > 0{
        
    
            performSegue(withIdentifier: "goSave", sender: nil)
            
            
            
            
        }//endif
        else{
            let alert = UIAlertController(title: "Gün Seçiniz!", message: "Lütfen Seçim Yapınız.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    } //end tapped
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSave" {
            let newVC = segue.destination as! RateTheDaySaveVC
            newVC.delegate = self
            newVC.getAddDayArray = addDayArray
            newVC.getStaj_id = getStaj_id
       
        }
   
    }//end prepare
    
    //loadURL
    
    func loadURL(url:String){

        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!



        
        let params: Parameters = [
            "token": retrieveToken,
            "kullanici_id": retrieveId,
            "staj_id": getStaj_id
        ]

        print(params)


        //        print(params)
        let path = URL(string:url)


        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in


                let result = response.result




                print(response)


                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let key = dict["gunler"] as? [Dictionary<String,AnyObject>]{

                        self.adet = key.count
                        for i in 0..<key.count{

                            
                            if let id = key[i]["id"] as? String{
                                
                                
                                
                                self.idJSON.append(id)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            
                            if let aciklama = key[i]["aciklama"] as? String{
                                
                                
                            
                                self.aciklamaJSON.append(aciklama)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let staj_tarihi = key[i]["staj_tarihi"] as? String{
                                
                                let staj_tarihiSplitBosluk = staj_tarihi.components(separatedBy: " ")
                                
                                
                                self.staj_tarihiJSON.append(staj_tarihiSplitBosluk[0])
                                
                                self.tableView.reloadData()
                                
                                
                            }





                        }


                    }
                }



        }
        
        self.tableView.reloadData()
    }
    //loadUrl end
    
    
    //loadURL2
    
    func loadURL2(url:String){
        
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
        
        
        
        let params: Parameters = [
            "token": retrieveToken,
            "kullanici_id": retrieveId,
            "staj_id": getStaj_id
        ]
        
        print(params)
        
        
        //        print(params)
        let path = URL(string:url)
        
        
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                
                
                let result = response.result
        
                
                
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let key = dict["gunler"] as? [Dictionary<String,AnyObject>]{
                        
                        self.adet = key.count
           
                        self.flagCount = self.adet
                      
                        print(self.flagCount)
                        self.checked = Array(repeating: false, count: self.flagCount)
                    }
                }
                
                
                
        }
        
        
        
    }
    //loadUrl2 end
    

 
    
    
    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popViewController(animated: true);
    }
    
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return aciklamaJSON.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? RateTheDayTVCell
      
        if !checked.isEmpty {
     
        if checked[indexPath.row] == false{
            cell?.accessoryType = .none
        } else if checked[indexPath.row] {
            cell?.accessoryType = .checkmark
            
        }
            
        }

        
        cell?.detail.text = String(aciklamaJSON[indexPath.row])
        cell?.date.text = String(staj_tarihiJSON[indexPath.row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checked[indexPath.row] = false
            } else {
                cell.accessoryType = .checkmark
                checked[indexPath.row] = true
                
                print(indexPath.row)
                addDayArray.append(Int(self.idJSON[indexPath.row])!)
              
                
                
                
            }
        }
    }
   
    
    //end TableView
    
    
    

}
