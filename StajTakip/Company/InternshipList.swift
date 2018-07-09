//
//  InternshipList.swift
//  StajTakip
//
//  Created by Serhan Akyol on 26.06.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire



class InternshipList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    var staj_idJSON = [String]()
    var bolum_adiJSON = [String]()
    var firma_adiJSON = [String]()
    var baslangic_tarihJSON = [String]()
    var bitis_tarihJSON = [String]()
    var puanJSON1 = [String]()
    var puanJSON2 = [String]()
    var puanJSON3 = [String]()
    var puanJSON4 = [String]()
    var sonucJSON = [String]()
    
    
    var selected:Int?
    var selectedButton:Int?
    var adet:Int = 0
    
    
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Yenilemek için çekiniz")
        refresher.addTarget(self, action: #selector(InternshipList.refresherFunc), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
       

        
        loadURL()
        
    }

  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadURL()
    }
    
 
    @objc func refresherFunc(){
        
        print("refresher ")
        
        
        staj_idJSON.removeAll()
        bolum_adiJSON.removeAll()
        firma_adiJSON.removeAll()
        baslangic_tarihJSON.removeAll()
        bitis_tarihJSON.removeAll()
        puanJSON1.removeAll()
        puanJSON2.removeAll()
        puanJSON3.removeAll()
        puanJSON4.removeAll()
        sonucJSON.removeAll()
        
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return staj_idJSON.count
        }
        
        loadURL()
    }
    
    //loadURL
    
    @objc func loadURL(){
        
        
        print("YENİ SONUÇLARRRRRRRRRR")
        
        let url = "http://bitirme.emre.pw/Firma/StajListele"
        
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
        
        
        let params: Parameters = [
            "token": retrieveToken,
            "firma_id": retrieveId
        ]
        
        
        
        //        print(params)
        let path = URL(string:url)
        
        self.tableView.reloadData()
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                
                
                let result = response.result
                
                
                
                
                print(response)
          
                
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let key = dict["list"] as? [Dictionary<String,AnyObject>]{
                        self.adet = key.count
                        
                        for i in 0..<key.count{
                            
                            
                            if let staj_id = key[i]["staj_id"] as? String{
                                
                               
                                self.staj_idJSON.append(staj_id)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            
                            if let baslangic_tarih = key[i]["baslangic_tarih"] as? String{
                                
                                
                                
                                let baslangicSplitBosluk = baslangic_tarih.components(separatedBy: " ")
                                self.baslangic_tarihJSON.append(baslangicSplitBosluk[0])
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let bitis_tarih = key[i]["bitis_tarih"] as? String{
                                
                                
                                let bitisSplitBosluk = bitis_tarih.components(separatedBy: " ")
                                self.bitis_tarihJSON.append(bitisSplitBosluk[0])
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let bolum_adi = key[i]["bolum_adi"] as? String{
                                
                                
                                
                                self.bolum_adiJSON.append(bolum_adi)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let ad_soyad = key[i]["ad_soyad"] as? String{
                                
                                
                                
                                self.firma_adiJSON.append(ad_soyad)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let puan = key[i]["puan"] as? String{
                                
                                
                            
                                print("debugg")
                                if Int(puan)! > 999 {
                                    let string = puan
                                    let characters = Array(string)
                     
                                if characters[0] != nil {
                                    self.puanJSON1.append(String(characters[0]))
                                }
                                else {
                                    self.puanJSON1.append("0")
                                }
                                if characters[1] != nil {
                                    self.puanJSON2.append(String(characters[1]))
                                }
                                else {
                                    self.puanJSON2.append("0")
                                }
                                if characters[2] != nil {
                                    self.puanJSON3.append(String(characters[2]))
                                }
                                else {
                                    self.puanJSON3.append("0")
                                }
                                if characters[3] != nil {
                                    self.puanJSON4.append(String(characters[3]))
                                }
                                else {
                                    self.puanJSON4.append("0")
                                }
                                } else {
                                    self.puanJSON1.append("0")
                                    self.puanJSON2.append("0")
                                    self.puanJSON3.append("0")
                                    self.puanJSON4.append("0")
                                }
                                
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let sonuc = key[i]["sonuc"] as? String{
                                
                                
                                 
                             
                                self.sonucJSON.append(sonuc)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            
                            self.tableView.reloadData()
                  
                        }
                    }
                }
                
                
                
        }
        
        self.tableView.reloadData()
        refresher.endRefreshing()
        self.tableView.reloadData()
    
    }
    //end loadURL
    
    
    
    
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staj_idJSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? InternshipListTVCell else {
            return UITableViewCell()
        }
      
       
       
        cell.sectionName.text = String(bolum_adiJSON[indexPath.row])
        cell.companyName.text = String(firma_adiJSON[indexPath.row])
        cell.firstDate.text = String(baslangic_tarihJSON[indexPath.row])
        cell.lastDate.text = String(bitis_tarihJSON[indexPath.row])
        cell.point.text = String(puanJSON1[indexPath.row])
        cell.point2.text = String(puanJSON2[indexPath.row])
        cell.point3.text = String(puanJSON3[indexPath.row])
        cell.point4.text = String(puanJSON4[indexPath.row])
        
        cell.cellButton.tag = indexPath.row
        cell.cellButton.addTarget(self, action: #selector(connected), for: .touchUpInside)
 
        if Int(sonucJSON[indexPath.row]) == -2 {
          
            cell.result.text = "Okul Stajı Reddetti"
           
        }
        if Int(sonucJSON[indexPath.row]) == -1 {
            cell.result.text = "Firma Stajı Reddetti"
        }
        if Int(sonucJSON[indexPath.row]) == 0 {
            cell.result.text = "Firmadan Onay Bekleniyor"
        }
        if Int(sonucJSON[indexPath.row]) == 1 {
            cell.result.text = "Okuldan Onay Bekleniyor"
        }
        if Int(sonucJSON[indexPath.row]) == 2 {
              print("22222222")
            cell.result.text = "Detay Girilebilir"
        }
        if Int(sonucJSON[indexPath.row]) == 3 {
            cell.result.text = "Firmadan Sonuç Bekleniyor"
        }
        if Int(sonucJSON[indexPath.row]) == 4 {
            print("girdii")
            cell.result.text = "Okuldan Sonuç Bekleniyor"
            print(cell.result.text)
        }
        if Int(sonucJSON[indexPath.row]) == 5 {
            cell.result.text = "İşlem Tamamlandı!"
            
            
        }
        
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
       
        performSegue(withIdentifier: "goChange", sender: nil)
    }
    
    
    
 
    
    //end TableView

 
    @objc func connected(sender: UIButton){
        selectedButton = sender.tag
        performSegue(withIdentifier: "goRate", sender: nil)
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goChange" {
            let newVC = segue.destination as! ChangeResultVC
            newVC.delegate = self
            newVC.getStaj_id = String(staj_idJSON[selected!])

            
            
        }
        if segue.identifier == "goRate" {
          
            let newVC = segue.destination as! RateTheDayVC
            newVC.delegate = self
            newVC.getStaj_id = String(staj_idJSON[selectedButton!])
            print("xx")
            print(String(staj_idJSON[selectedButton!]))
     
            
        }
    }//end prepare
    
    
    

}
