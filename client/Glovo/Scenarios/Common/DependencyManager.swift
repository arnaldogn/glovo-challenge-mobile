//
//  DependencyManager.swift
//  Glovo
//
//  Created by Arnaldo on 11/21/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import Swinject

public class DependencyManager {
    private lazy var container: Container = {
        let container = Container()
        container.register(APIManagerProtocol.self) { _ in APIManager() }.inObjectScope(.container)
        container.register(SearchCountryServiceProtocol.self) { _ in SearchCountryService() }
        container.register(SearchCityServiceProtocol.self) { _ in SearchCityService() }
        container.register(CitySelectorController.self) {
            return CitySelectorController(service: $0.resolve(SearchCountryServiceProtocol.self)!)
        }
        return container
    }()
    
    public static let shared = DependencyManager()
    
    public func bind<T>(interface: T.Type, to assembly: T) {
        container.register(interface) { _ in assembly }
    }
    
    public func resolve<T>(interface: T.Type) -> T! {
        return container.resolve(interface)
    }
    
    init() {}
}

public extension DependencyManager {
    
    static func bind<T>(interface: T.Type, to assembly: T) {
        DependencyManager.shared.bind(interface: interface, to: assembly)
    }
    
    static func resolve<T>(interface: T.Type) -> T! {
        return DependencyManager.shared.resolve(interface: interface)
    }
}

