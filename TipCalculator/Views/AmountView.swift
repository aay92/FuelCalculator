//
//  AmountView.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 20.09.2023.
//

import UIKit

class AmountView: UIView {
    
    private let title: String
    private let textAlignment: NSTextAlignment
    
    private lazy var titleLabel: UILabel = {
        LabelFacrory.build(
            text: title,
            font: ThemeFont.regular(ofSize: 15),
            textColor: ThemeColor.text,
            textAligment: textAlignment)
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = textAlignment
        label.textColor = ThemeColor.primary
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [.font: ThemeFont.bold(ofSize: 20)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 16)],
                           range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,amountLabel])
        stack.axis = .vertical
        return stack
    }()
    
    init(title: String, textAlignment: NSTextAlignment) {
        self.title = title
        self.textAlignment = textAlignment
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(amount: Double){
        let text = NSMutableAttributedString(
            string: amount.currencyFormatted,
            attributes: [.font: ThemeFont.bold(ofSize: 24)])
        text.addAttributes(
            [.font: ThemeFont.bold(ofSize: 16)],
            range: NSMakeRange(0, 1))
        amountLabel.attributedText = text
    }
    
    private func layout(){
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

