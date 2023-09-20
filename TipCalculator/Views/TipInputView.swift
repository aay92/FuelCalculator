//
//  TipInputView.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 17.09.2023.
//
import UIKit

class TipInputView: UIView {
    init(){
        super.init(frame: .zero)
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func layout(){
        backgroundColor = .gray
    }
}