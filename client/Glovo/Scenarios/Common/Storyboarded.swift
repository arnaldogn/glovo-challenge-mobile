//
//  Storyboarded.swift
//  Glovo
//
//  Created by Arnaldo on 11/21/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate(from storyboard: Storyboard) -> Self
}

extension Storyboarded {
    static func instantiate(from storyboard: Storyboard = .Main) -> Self {
        return instantiate(from: storyboard)
    }
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(from storyboard: Storyboard) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        return storyboard.instance.instantiateViewController(withIdentifier: className) as! Self
    }
}
