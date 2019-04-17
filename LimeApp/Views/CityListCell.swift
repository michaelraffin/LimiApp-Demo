//
//  CityListCell.swift
//  LimeApp
//
//  Created by Go ETU on 4/17/19.
//  Copyright © 2019 Michael. All rights reserved.
//

import UIKit

class CityListCell: UITableViewCell {

    @IBOutlet weak var lblAbriv: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var imgBanner: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgBanner.layer.masksToBounds = false
        imgBanner.layer.cornerRadius = imgBanner.frame.height/2
        imgBanner.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
