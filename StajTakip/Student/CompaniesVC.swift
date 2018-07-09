
import UIKit
import Alamofire

class CompaniesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var refresher: UIRefreshControl!
    
    var jsonAdi = [String]()
    var jsonid = [String]()
    var selected:Int?
    
    var delegate:LoginVC?
    var companiesArray = [Companies]()
    var currentCompaniesArray = [Companies]() //update table
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Yenilemek için çekiniz")
        refresher.addTarget(self, action: #selector(CompaniesVC.refresherFunc), for: UIControlEvents.valueChanged)
        table.addSubview(refresher)
        
        
        table.reloadData()
    
        
        loadURL()
        setUpSearchBar()
        alterLayout()
     
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // servis baş
    
    
    @objc func refresherFunc(){
        
        print("refresher ")
        
        
        jsonAdi.removeAll()
        jsonid.removeAll()
        companiesArray.removeAll()
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return jsonid.count
        }
        
        loadURL()
    }
    
    func loadURL(){
        
        
        let url = "http://bitirme.emre.pw/Firma/Listele"
        var retrieveToken = UserDefaults.standard.string(forKey: "token")!
 

        

        let params: Parameters = [
            "token": retrieveToken
        ]
        
  
        
//        print(params)
        let path = URL(string:url)
        
        
        Alamofire.request(path!, method: .post, parameters: params, encoding: URLEncoding.httpBody)
            .responseJSON { response in
             
                    
                    let result = response.result
                    
                    
                    
                
                    print(response)
                
                
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let key = dict["list"] as? [Dictionary<String,AnyObject>]{
                  
                        
                        for i in 0..<key.count{
                            
                            
                            if let adi = key[i]["adi"] as? String{
                                
                                
                                self.jsonAdi.append(adi)
                                self.companiesArray.append(Companies(name: adi))
                                self.table.reloadData()
                                self.setUpCompanies()
                          
                                self.table.reloadData()
                               
                            }
                            if let id = key[i]["id"] as? String{
                                
                                
                                self.jsonid.append(id)
                                self.table.reloadData()
                                
                            }
                            
                            
                  
                            
                            
                            
                        }
                    }
                }
 
       
               
        }
        self.table.reloadData()
        refresher.endRefreshing()
        self.table.reloadData()
    }
    
    
    
    
    
    
    
    
    
    // servis son
    private func setUpCompanies() {
        
        //companiesArray.append(Companies(name: "Amber"))
     
        
        
        currentCompaniesArray = companiesArray
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func alterLayout() {
        table.tableHeaderView = UIView()
        // search bar in section header
        table.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
        searchBar.placeholder = "Firma Aratın"
  
    }
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonid.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CompaniesTVCell else {
            return UITableViewCell()
        }
        cell.nameLbl.text = currentCompaniesArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "compDetails", sender: nil)
    }

  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "compDetails" {
            let newVC = segue.destination as! CompaniesDetailsVC
            newVC.delegate = self
            newVC.getAdi = String(jsonAdi[selected!])
            newVC.getid = String(jsonid[selected!])
//            newVC.getBrandId = String(jsonId[selected!])
       
        }
    }
    
    
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentCompaniesArray = companiesArray.filter({ companies -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return companies.name.lowercased().contains(searchText.lowercased())
                
            default:
                return false
            }
        })
        table.reloadData()
    }
    
    
}

class Companies {
    let name: String
    
    
    init(name: String) {
        self.name = name
        
    }
}


