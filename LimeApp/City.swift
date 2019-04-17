//
//  City.swift
//  LimeApp
//
//  Created by Go ETU on 4/17/19.
//  Copyright © 2019 Michael. All rights reserved.
//

import Foundation

import SwiftyJSON
class ListCity :Decodable {
    let data = [Country]()
}
class Country : Decodable  {
    var banner :String?
    var color  :String?
    var country_code  :String?
    var id  :String?
    var latitude :Double?
    var longitude :Double?
    var name :String?
    var population  :Int?
    var subtitle :String?
    var type  :String?
    var  zoom :Int?
    
    init (json : [String:Any]){
//        banner = json["banner"] as? Int
        name = json["name"] as? String ?? ""
        banner = json["banner"] as? String ?? ""
        subtitle =  json["banner"] as? String ?? ""
    
    }
}
