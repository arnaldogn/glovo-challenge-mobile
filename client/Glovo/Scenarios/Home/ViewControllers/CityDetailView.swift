//
//  CityDetailView.swift
//  Glovo
//
//  Created by Arnaldo on 11/21/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import UIKit

class CityDetaiView: UIView {
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var timeZoneLbl: UILabel!
    
    func configure(with city: CityDataModel) {
        cityLbl.text = city.name
        currencyLbl.text = city.currencyCode
        timeZoneLbl.text = city.timeZone
    }
}
