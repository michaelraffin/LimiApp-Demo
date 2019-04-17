//
//  SearchCityVC.swift
//  LimeApp
//
//  Created by Go ETU on 4/17/19.
//  Copyright © 2019 Michael. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire
import SwiftyJSON
import Kingfisher
protocol searchActionDelegate{
    func getRecent(value:String)
}
class SearchCityVC: UIViewController,UISearchResultsUpdating,UISearchBarDelegate {
    var delegate :searchActionDelegate!
    @IBOutlet weak var tableVIew: UITableView!
    var countryList = [Country]()
    let searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 440, height: 40))
    var filetredCountry = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVIew.dataSource = self
        tableVIew.delegate = self
        displayCiy { (data, error) in
            if data!.count > 2 {
                let resp = try! JSONDecoder().decode([Country].self, from: data!)
                self.countryList = resp
                self.filetredCountry = self.countryList
                print(self.countryList.count)
                self.tableVIew.reloadData()
            }
        }
        setupView()
    }
    func setupView(){
        searchBar.delegate = self
        self.navigationController!.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        searchBar.placeholder = "Search for a city"
        self.navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        tableVIew.rowHeight = 60
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCity(value: searchText) { (data, error) in
            if data != nil {
                let resp = try! JSONDecoder().decode([Country].self, from: data!)
                self.countryList = resp
                self.filetredCountry = self.countryList
                print(self.countryList.count)
                self.tableVIew.reloadData()
            }
            
        }
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.isHidden =  false
    }
}
//Table view
extension SearchCityVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityListCell
        let data = countryList[indexPath.row]
        cell.lblCountryName.text = data.name
        if data.banner != nil{
            cell.lblAbriv.isHidden = true
            let url = URL(string:data.banner!)
            cell.imgBanner.kf.indicatorType = .activity
            cell.imgBanner.kf.setImage(with: url,options: [.transition(.fade(0.2))])
        }else {
            cell.lblAbriv.isHidden = false
            cell.lblAbriv.text = String(describing: data.name!.prefix(3)).capitalized
            cell.imgBanner.maskWith(color: hexStringToUIColor(hex: data.color!))
        }
        
        cell.lblCityName.text = data.subtitle
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.getRecent(value: countryList[indexPath.row].name!)
        navigationController?.popViewController(animated: true)
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
extension UIImageView {
    func maskWith(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
    
}
extension SearchCityVC :  UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSLog("Table view scroll detected at offset: %f", scrollView.contentOffset.y)
        self.searchBar.endEditing(true)
    }
}

extension SearchCityVC {
    func displayCiy(completion : @escaping (Data?,Error?) -> Void){
        let urlString = "https://lemi.travel/api/v5/cities"
        _ = URL(string: urlString)!
        Alamofire.request(urlString)
            .validate()
            .responseJSON { response in
                
                print (response)
                switch response.result {
                case .success( _):
                    completion(response.data!,nil)
                case .failure(let error):
                    completion(nil,error)
                    break             }
        }
        
    }
    func searchCity(value:String,completion : @escaping (Data?,Error?) -> Void){
        let urlString = "https://lemi.travel/api/v5/cities?q=\(value)"
        Alamofire.request(urlString)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    if  response.data!.count > 2 {
                        completion(response.data!,nil)
                    }else {
                        completion(nil,nil)
                    }
                case .failure(let error):
                    completion(nil,error)
                    break             }
        }
        
        
        
    }
    
}
