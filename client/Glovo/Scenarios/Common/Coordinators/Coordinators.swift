//
//  Coordinators.swift
//  Glovo
//
//  Created by Arnaldo on 11/21/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
