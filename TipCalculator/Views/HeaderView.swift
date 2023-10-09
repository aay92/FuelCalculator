//
//  HeaderView.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 25.09.2023.
//

import UIKit

class HeaderView: UIView {
    
    private let topLabel : UILabel = {
        LabelFacrory.build(
            text: nil,
            font: ThemeFont.bold(ofSize: 17))
    }()
    
    private let bottomLabel : UILabel = {
        LabelFacrory.build(
            text: nil,
            font: ThemeFont.bold(ofSize: 15))
    }()
    
    private let topViewSpacer = UIView()
    private let bottomViewSpacer = UIView()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            topViewSpacer,
            topLabel,
            bottomLabel,
            bottomViewSpacer
        ])
        stack.axis = .vertical
        stack.spacing = -4
        stack.alignment = .leading
        return stack
    }()
    
    init(){
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topViewSpacer.snp.makeConstraints { make in
            make.height.equalTo(bottomViewSpacer)
        }
    }
    
    func configure(topText: String, bottomText: String){
        topLabel.text = topText
        bottomLabel.text = bottomText
    }
}

