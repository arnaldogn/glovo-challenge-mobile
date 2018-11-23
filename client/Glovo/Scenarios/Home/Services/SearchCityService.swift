//
//  SearchCityService.swift
//  Glovo
//
//  Created by Arnaldo on 11/20/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import Foundation

typealias FetchCityCompletion = (City?, Error?) -> ()
typealias FetchCitiesCompletion = ([City]?, Error?) -> ()

protocol SearchCityServiceProtocol {
    func fetch(name: String, completion: @escaping FetchCityCompletion)
    func fetch(completion: @escaping FetchCitiesCompletion)
}

struct SearchCityService: SearchCityServiceProtocol {
    enum Constants {
        static let CitiesURL = UrlConstants.baseURL + "cities/"
    }
    
    internal func fetch(name: String, completion: @escaping FetchCityCompletion) {
        DependencyManager.resolve(interface: APIManagerProtocol.self).request(url: Constants.CitiesURL + name, completion: completion)
    }
    
    internal func fetch(completion: @escaping FetchCitiesCompletion) {
        DependencyManager.resolve(interface: APIManagerProtocol.self).request(url: Constants.CitiesURL, completion: completion)
    }
}
