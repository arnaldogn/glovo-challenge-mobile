//
//  SearchCountryService.swift
//  Glovo
//
//  Created by Arnaldo on 11/21/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import Foundation

typealias FetchCountriesCompletion = ([Country]?, Error?) -> ()

protocol SearchCountryServiceProtocol {
    func fetch(completion: @escaping FetchCountriesCompletion)
}

struct SearchCountryService: SearchCountryServiceProtocol {
    enum Constants {
        static let countriesURL = UrlConstants.baseURL + "countries"
    }
    
    internal func fetch(completion: @escaping FetchCountriesCompletion) {
        DependencyManager.resolve(interface: APIManagerProtocol.self).request(url: Constants.countriesURL, completion: completion)
    }
}
