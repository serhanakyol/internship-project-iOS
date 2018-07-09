//
//  MyInternshipViewController.swift
//  StajTakip
//
//  Created by Serhan Akyol on 27.05.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class MyInternshipViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    
    @IBOutlet weak var tableView: UITableView!
    

    
 
    var refresher: UIRefreshControl!
    var firma_adiJson = [String]()
    var staj_idJSON = [String]()
    var baslangic_tarihJSON = [String]()
    var bitis_tarihiJSON = [String]()
    var sonucJSON = [String]()
    
    var selected:Int?
    var adet:Int = 0
    
    var delegate:LoginVC?
    var companiesArray = [Companies]()
    var currentCompaniesArray = [Companies]() //update table
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
   
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Yenilemek için çekiniz")
        refresher.addTarget(self, action: #selector(MyInternshipViewController.refresherFunc), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        
        tableView.reloadData()
        
        
        
        loadURL()
       
        
    }
    
    @objc func refresherFunc(){
        
        print("refresher ")
        
        
         firma_adiJson.removeAll()
         staj_idJSON.removeAll()
         baslangic_tarihJSON.removeAll()
         bitis_tarihiJSON.removeAll()
         sonucJSON.removeAll()
        
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return staj_idJSON.count
        }
        
        loadURL()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // servis baş
    
    
    
    
    @objc func loadURL(){
        
        let url = "http://bitirme.emre.pw/Staj/Listele"
        
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
                
                
                
                
                print(response)
                
                
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let key = dict["stajlarim"] as? [Dictionary<String,AnyObject>]{
                          self.adet = key.count
                        
                        print(self.adet)
                        for i in 0..<key.count{
                            
                            
                            if let bolum_adi = key[i]["firma_adi"] as? String{
                                
                                
                                self.firma_adiJson.append(bolum_adi)
 
                                self.tableView.reloadData()
                             
                                
                            }
                            if let baslangic_tarih = key[i]["baslangic_tarih"] as? String{
                                
                                
                                let baslangicSplitBosluk = baslangic_tarih.components(separatedBy: " ")
                                self.baslangic_tarihJSON.append(baslangicSplitBosluk[0])
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let bitis_tarih = key[i]["bitis_tarih"] as? String{
                                
                                let bitisSplitBosluk = bitis_tarih.components(separatedBy: " ")
                                self.bitis_tarihiJSON.append(bitisSplitBosluk[0])
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let staj_id = key[i]["staj_id"] as? String{
                                
                                
                                self.staj_idJSON.append(staj_id)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let sonuc = key[i]["sonuc"] as? String{
                                
                                
                                self.sonucJSON.append(sonuc)
                                
                                self.tableView.reloadData()
                                
                                
                            }

                            
                            
                            
                            
                            
                        }
                    }
                }
                
                
                
        }
        self.tableView.reloadData()
        refresher.endRefreshing()
        self.tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
 
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staj_idJSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? MyIntershipTCell else {
            return UITableViewCell()
        }
        cell.name.text = String(firma_adiJson[indexPath.row])
        cell.firstDate.text = String(baslangic_tarihJSON[indexPath.row])
        cell.lastDate.text = String(bitis_tarihiJSON[indexPath.row])
  
        if Int(sonucJSON[indexPath.row]) == -2 {
            cell.result.text = "Okul Reddetti"
        }
        if Int(sonucJSON[indexPath.row]) == -1 {
            cell.result.text = "Firma Reddetti"
        }
        if Int(sonucJSON[indexPath.row]) == 0 {
            cell.result.text = "Firma Onayı Bekliyor"
        }
        if Int(sonucJSON[indexPath.row]) == 1 {
            cell.result.text = "Okul Onayı Bekliyor"
        }
        if Int(sonucJSON[indexPath.row]) == 2 {
            cell.result.text = "Detay Girilebilir"
        }
        if Int(sonucJSON[indexPath.row]) == 3 {
            cell.result.text = "Firma Sonuç Bekleniyor"
        }
        if Int(sonucJSON[indexPath.row]) == 4 {
            cell.result.text = "Okul Sonuç Bekleniyor"
        }
        if Int(sonucJSON[indexPath.row]) == 5 {
            cell.result.text = "Tamamlandı!"
        }
        
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "goDay", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDay" {
            let newVC = segue.destination as! DayVC
            newVC.delegate = self
            newVC.getStaj_id = String(staj_idJSON[selected!])
            newVC.getBaslangic_tarih = String(baslangic_tarihJSON[selected!])
            newVC.getBitis_tarih = String(bitis_tarihiJSON[selected!])
            newVC.getResult = String(sonucJSON[selected!])
            
        }
    }
    
    
  
    
    
 
    
    
 
    
    

}

