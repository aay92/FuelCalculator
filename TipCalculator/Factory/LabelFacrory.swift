//
//  LabelFacrory.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 19.09.2023.
//

import UIKit

struct LabelFacrory {
    static func build(text: String?,
                      font: UIFont,
                      backgruondColor:
                      UIColor = .clear,
                      textColor: UIColor = ThemeColor.text,
                      textAligment: NSTextAlignment = .center) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.backgroundColor = backgruondColor
        label.textColor = textColor
        label.textAlignment = textAligment
        return label
    }
}
