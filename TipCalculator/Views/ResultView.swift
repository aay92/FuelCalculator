//
//  ResultView.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 17.09.2023.
//
import UIKit

class ResultView: UIView {
    
    private let headerLabel : UILabel = {
        LabelFacrory.build(text: "Total person",
                           font: ThemeFont.demiBold(ofSize: 18))
    }()
    
    private let amountPerPerson : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [.font: ThemeFont.bold(ofSize: 10)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)], range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separator
        return view
    }()

    private lazy var vStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            headerLabel,
            amountPerPerson,
            horizontalLineView,
            buildSpacerView(height: 0),///view - просто разделитель
            hStackView
        ])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let totalBillView: AmountView = {
        let view = AmountView(
            title: "Общая стоимость",
            textAlignment: .left)
        return view
    }()
    
    private let totalTipView: AmountView = {
        let view = AmountView(
            title: "Общая стоимость",
            textAlignment: .right)
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            totalBillView,
            UIView(),///Пустая вью , чтобы был промежуток
            totalTipView
        ])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    private func buildSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
    
    init(){
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(result: ResultData){
        let text = NSMutableAttributedString(
            string: String(result.amountPerPerson.currencyFormatted),
            attributes: [.font: ThemeFont.bold(ofSize: 48)])
        text.addAttributes(
            [.font: ThemeFont.bold(ofSize: 34)],
            range: NSMakeRange(0, 1))
        amountPerPerson.attributedText = text
        
        totalBillView.configure(amount: result.totalBill)
        totalBillView.configure(amount: result.totalTill)

    }
    
    private func layout(){
        backgroundColor = .white
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.bottom.equalTo(snp.bottom).offset(-24)
        }
        
        horizontalLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        
        addShadow(offset: CGSize(width: 0, height: 3),
                  color: .black,
                  radius: 12.0,
                  opacity: 0.1)
    }
}

