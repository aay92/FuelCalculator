//
//  Tip.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 25.09.2023.
//

import UIKit

enum Tip {
    case none
    case tenPercent
    case fifteenPercent
    case twentyPercent
    case customPercent(value: Int)
    
    var caseStringValue: String {
        switch self {
        case .none:
            return ""
        case .tenPercent:
            return "10%"
        case .fifteenPercent:
            return "15%"
        case .twentyPercent:
            return "20%"
        case .customPercent(let value):
            return String(value)
        }
    }
}
