//
//  Double + Extension.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 30.09.2023.
//

import UIKit

extension Double {
    var currencyFormatted: String {
        var isWholeNumber: Bool {
            isZero ? true : !isNormal ? false: self == rounded()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        return formatter.string(for: self) ?? ""
    }
}
