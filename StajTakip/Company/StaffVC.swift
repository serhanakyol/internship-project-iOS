//
//  StaffVC.swift
//  StajTakip
//
//  Created by Serhan Akyol on 21.06.2018.
//  Copyright © 2018 Serhan Akyol. All rights reserved.
//

import UIKit
import Alamofire

class StaffVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var refresher: UIRefreshControl!
    
    
    var kullanici_idJSON = [String]()
    var gorevJSON = [String]()
    var ad_soyadJSON = [String]()
    var epostaJSON = [String]()

    
    var selected:Int?
    var adet:Int = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Yenilemek için çekiniz")
        refresher.addTarget(self, action: #selector(StaffVC.refresherFunc), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        
        
        loadURL()
        
    }

   
    
    
    @objc func refresherFunc(){
        
        print("refresher ")
        
        
        gorevJSON.removeAll()
        epostaJSON.removeAll()
        ad_soyadJSON.removeAll()
        kullanici_idJSON.removeAll()
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return kullanici_idJSON.count
        }
        
        loadURL()
    }
    
    
    //loadURL
    
    @objc func loadURL(){
        
        
        let url = "http://bitirme.emre.pw/Firma/PersonelListele"
        
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
        var retrieveId = UserDefaults.standard.string(forKey: "id")!
        
        
        
        let params: Parameters = [
            "token": retrieveToken,
            "firma_id": retrieveId
        ]
        
        
        
        //        print(params)
        let path = URL(string:url)
        
        
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                
                
                let result = response.result
                
                
                
                
                print(response)
                
                
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let key = dict["list"] as? [Dictionary<String,AnyObject>]{
                        self.adet = key.count
                      
                        for i in 0..<key.count{
                            
                            
                            if let kullanici_id = key[i]["kullanici_id"] as? String{
                                
                                
                                print(kullanici_id)
                                self.kullanici_idJSON.append(kullanici_id)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let gorev = key[i]["gorev"] as? String{
                                
                                
                               
                                self.gorevJSON.append(gorev)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let ad_soyad = key[i]["ad_soyad"] as? String{
                                
                                
                                self.ad_soyadJSON.append(ad_soyad)
                                
                                self.tableView.reloadData()
                                
                                
                            }
                            if let eposta = key[i]["eposta"] as? String{
                                
                                
                                self.epostaJSON.append(eposta)
                                print(eposta)
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
    //end loadURL
    
    
    // TableView
    
  
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kullanici_idJSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? StaffTVCell else {
            return UITableViewCell()
        }
        cell.mailLabel.text = ""
        cell.mailLabel.text = String(epostaJSON[indexPath.row])

   
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "goRemove", sender: nil)
    }
    
    
    //end TableView
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goRemove" {
            let newVC = segue.destination as! RemoveStaffVC
            newVC.delegate = self
            newVC.getid = String(kullanici_idJSON[selected!])
            newVC.getEmail = String(epostaJSON[selected!])
      
            
        }
    }
    
    
    

}
