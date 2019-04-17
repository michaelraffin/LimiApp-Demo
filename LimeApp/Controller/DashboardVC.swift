//
//  ViewController.swift
//  LimeApp
//
//  Created by Go ETU on 4/17/19.
//  Copyright © 2019 Michael. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    
    @IBOutlet weak var lblSelectedCity: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSelectedCity.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isToolbarHidden = true
        self.navigationController!.navigationBar.isHidden =  true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func btnSearchTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchCityID") as! SearchCityVC
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DashboardVC : searchActionDelegate {
    func getRecent(value: String) {
        lblSelectedCity.isHidden = false
        lblSelectedCity.text = "You selected: \(value)"
    }
    
    
}
