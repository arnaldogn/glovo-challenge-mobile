//
//  CityDataModel.swift
//  Glovo
//
//  Created by Arnaldo on 11/21/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import Foundation

struct CityDataModel {
    let city: City
    
    var name: String {
        return city.name
    }
    var currencyCode: String {
        return city.countryCode
    }
    var timeZone: String {
        return city.timeZone ?? ""
    }
}
