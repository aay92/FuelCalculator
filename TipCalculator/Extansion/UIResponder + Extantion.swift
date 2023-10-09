//
//  UIResponder + Extention.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 01.10.2023.
//

import UIKit

extension UIResponder {
    var parcentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parcentViewController
    }
}
