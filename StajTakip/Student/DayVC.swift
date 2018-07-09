//
//  DayVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 31.05.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class DayVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate:MyInternshipViewController?
    var getStaj_id = String()
    var getBaslangic_tarih = String()
    var getBitis_tarih = String()
    var getResult = String()
    var dayCount:Int = 0
    var count:Int?
    
    var refresher: UIRefreshControl!
    var selected:Int?
 
    var staj_tarihiJSON = [String]()
    var aciklamaJSON = [String]()
    var staj_idJSON = [String]()
    
    
   
    var adet:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
       
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Yenilemek için çekiniz")
        refresher.addTarget(self, action: #selector(DayVC.refresherFunc), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let start = dateFormatter.date(from: getBaslangic_tarih)!
        let end = dateFormatter.date(from: getBitis_tarih)!
        
        let diff = Date.daysBetween(start: start, end: end)
        dayCount = diff
      
        
       
        loadURL()
        
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let url = "http://bitirme.emre.pw/Staj/SonucDegistir"
        
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
        
        
        let params: Parameters = [
            "token": retrieveToken,
            "staj_id": getStaj_id,
            "sonuc": 3
        ]
        
        
        
        //        print(params)
        let path = URL(string:url)
        
        
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                
                
                let result = response.result
                print(response)
                let alert = UIAlertController(title: "Tamamlandı.", message: "Staj işlemleri tamamlandı.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
        }
        
        
    }
    
    @objc func refresherFunc(){
        
        print("refresher ")
        
       
        staj_tarihiJSON.removeAll()
        aciklamaJSON.removeAll()
        staj_idJSON.removeAll()
     
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return staj_idJSON.count
        }
        
        loadURL()
    }
    
    
    
 
    
    
    //loadURL
    
    @objc func loadURL(){
       
         let url = "http://bitirme.emre.pw/Staj/RaporListele"
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
        
        let firstDate = getBaslangic_tarih.components(separatedBy: " ")
        let lastDate = getBitis_tarih.components(separatedBy: " ")
        
        
     
        print(firstDate[0])
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
                            
                            if let aciklama = key[i]["aciklama"] as? String{
                                
                                
                                self.aciklamaJSON.append(aciklama)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let id = key[i]["id"] as? String{
                                
                                
                                self.staj_idJSON.append(id)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let staj_tarihi = key[i]["staj_tarihi"] as? String{
                                
                                
                                let tarihSplitBosluk = staj_tarihi.components(separatedBy: " ")

                                
                                self.staj_tarihiJSON.append(tarihSplitBosluk[0])
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            
                            
                            if let key1 = key[i]["resimler"] as? [Dictionary<String,AnyObject>]{
                             
                                
                                for i in 0..<key1.count{
                                    
                                    
                                    if let photoCat = key1[i]["id"] as? String{
                                        
                                        
                                        print("idasdaslkdasdasldkaslşdkaslşdkaslş")
                                        print(photoCat)
//                                        var resimUrl = NSURL(string: photoCat as! String)
//
//                                        var resimData = NSData(contentsOf: resimUrl! as URL)
                                        
//                                        self.getPath.append(resimData!)
//                                        self.photoView()
                                    }
                                    
                                    
                                }
                            }
                 
                            
                            
          
                        }
                        
                        
                    }
                }
                
                
                
        }
        
        self.tableView.reloadData()
        refresher.endRefreshing()
        self.tableView.reloadData()
    }
//loadUrl end
    
    
    
    
    
    //tableView
    
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staj_idJSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? DayTVCell else {
            return UITableViewCell()
        }
        
        

       
     
        cell.name.text = String(aciklamaJSON[indexPath.row])
        
        cell.date.text = String(staj_tarihiJSON[indexPath.row])
        
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "goDayDetail", sender: nil)
    }
    
 
    // tableView End


    @IBAction func addDayGo(_ sender: Any) {
        if getResult == "2"  {
            performSegue(withIdentifier: "goAddDay", sender: nil)
        }
        else {
            let alert = UIAlertController(title: "Yetkiniz Bulunmamakta!", message: "Gün eklemek için yetkiniz bulunmamaktadır.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goDayDetail" {
         
            let newVC = segue.destination as! DayOrgDetailVC
            newVC.delegate1 = self
            newVC.tarih = String(staj_tarihiJSON[selected!])
            newVC.aciklama = String(aciklamaJSON[selected!])
            newVC.stajId = String(staj_idJSON[selected!])
         
        }
        
        if segue.identifier == "goAddDay" {
            let newVC = segue.destination as! AddDayVC
            newVC.delegate = self
            newVC.baslangicTarih = String(getBaslangic_tarih)
            newVC.bitisTarih = String(getBitis_tarih)
            newVC.stajId = String(getStaj_id)
           
        }
        
        

        
    }

    



}





//class end

extension Date {
    
    func daysBetween(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
}
