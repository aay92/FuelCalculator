//
//  UIView + Extansion.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 20.09.2023.
//

import UIKit

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float){
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        let backgroundCGColor = backgroundColor?.cgColor
        layer.backgroundColor = backgroundCGColor
    }
    
    func addCornerRadius(radius: CGFloat){
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
    
    func addRaundedCorners(corners: CACornerMask, radius: CGFloat){
        layer.cornerRadius = radius
        layer.maskedCorners = [corners]
    }
}
