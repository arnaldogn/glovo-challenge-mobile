//
//  MainCoordinator.swift
//  Glovo
//
//  Created by Arnaldo on 11/21/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
      showDashboard()
    }
    
    func showDashboard() {
        let homeVC = HomeViewController.instantiate()
        homeVC.service = DependencyManager.resolve(interface: SearchCityServiceProtocol.self)
        navigationController.pushViewController(homeVC, animated: true)
    }
}

