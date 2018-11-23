//
//  City.swift
//  Glovo
//
//  Created by Arnaldo on 11/20/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import Foundation

struct City: Decodable {
    let code: String
    let name: String
    let workingArea: [String]
    let countryCode: String
    let currency: String?
    let enabled: Bool?
    let timeZone: String?
    let busy: Bool?
    let languajeCode: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case workingArea = "working_area"
        case countryCode = "country_code"
        case currency
        case enabled
        case timeZone = "time_zone"
        case busy
        case languajeCode = "languaje_code"
    }
}
