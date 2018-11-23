//
//  UIView+Extensions.swift
//  Glovo
//
//  Created by Arnaldo on 11/21/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviewsForAutolayout(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    func addConstraints(_ constraints: [NSLayoutConstraint]...) {
        addConstraints(constraints.flatMap { $0 })
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension NSLayoutConstraint {
    static func constraints(_ visualFormat: String, views: [String: Any],
                            options: NSLayoutConstraint.FormatOptions = [], metrics: [String: Any]? = nil) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: options, metrics: metrics, views: views)
    }
}
