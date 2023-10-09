//
//  CalculatorVC.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 17.09.2023.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorVC: UIViewController {

    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var vStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            UIView()
        ])
        stack.axis = .vertical
        stack.spacing = 36
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        observe()
    }
    
    ///view model
    private let vm = CalculaterVM()
    private var cansellables = Set<AnyCancellable>()
    
    ///gesture
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: nil)
        tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    func bind(){
        ///view model Input
        let input = CalculaterVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher, 
            logoViewTapPublisher: logoViewTapPublisher)
        
        let output = vm.transform(input: input)
        
        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configure(result: result)
        }.store(in: &cansellables)
        
        output.resetCalculaterPublisher.sink { [unowned self] _ in
            billInputView.reset()
            tipInputView.reset()
            splitInputView.reset()
            
            ///Animate logo view after reset
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                usingSpringWithDamping: 5.0,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut) {
                    self.logoView.transform = .init(scaleX: 1.2, y: 1.2)
                } completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        self.logoView.transform = .identity
                    }
                }
        }.store(in: &cansellables)
    }
    
    private func observe() {
        viewTapPublisher.sink { [unowned self] taps in
            view.endEditing(true)///грубо говоря убираем клавиатуру при нажатие на любой участок вью
        }.store(in: &cansellables)
    }
    
    private func layout(){
        view.backgroundColor = ThemeColor.bg
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        resultView.snp.makeConstraints { make in
            make.height.equalTo(220)
        }
        billInputView.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+16)
        }
        splitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
    
}

