//
//  LogoView.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 17.09.2023.
//

import UIKit

class LogoView: UIView {
    
    private let logoImage: UIImageView = {
        let images = UIImageView(image: .init(named: "avatar"))
        images.contentMode = .scaleAspectFit
        return images
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(
            string: "Mr CalFuol",
            attributes: [.font: ThemeFont.demiBold(ofSize: 16)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)], range: NSMakeRange(0,10))
        label.attributedText = text
        return label
    }()
    
    private let bottomLabel : UILabel = {
        LabelFacrory.build(text: "Калкулятор бензина",
                           font: ThemeFont.demiBold(ofSize: 20),
                           textAligment: .left)
    }()
    
    private lazy var vStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [topLabel, bottomLabel])
        stack.axis = .vertical
        stack.spacing = -4
        stack.alignment = .center
        return stack
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logoImage, vStackView])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    init(){
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){

        addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints { make in
            make.height.equalTo(logoImage.snp.width)
        }
    }
}

