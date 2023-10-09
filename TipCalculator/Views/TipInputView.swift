//
//  TipInputView.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 17.09.2023.
//
import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(
            topText: "Choose",
            bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        ///combine
        button.tapPublisher.flatMap({
            Just(Tip.tenPercent)
        })
        .assign(to: \.value, on: tipSubject)
        .store(in: &cancellable)
        return button
    }()
    
    private lazy var fifteenPercentButton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        ///combine
        button.tapPublisher.flatMap({
            Just(Tip.fifteenPercent)
        })
        .assign(to: \.value, on: tipSubject)
        .store(in: &cancellable)
        return button
    }()
    
    private lazy var twentyPercentButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        ///combine
        button.tapPublisher.flatMap({
            Just(Tip.twentyPercent)
        })
        .assign(to: \.value, on: tipSubject)
        .store(in: &cancellable)
        return button
    }()
    
    private lazy var customButton: UIButton = {
        let button = UIButton()
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        button.tapPublisher.sink {[unowned self] _ in
            handleCustomTipButton()
        }.store(in: &cancellable)
        return button
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            tenPercentButton,
            fifteenPercentButton,
            twentyPercentButton
        ])
        stack.axis = .horizontal
        stack.spacing = 18
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var buttonVStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            buttonHStackView,
            customButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    ///combine
    private let tipSubject: CurrentValueSubject<Tip, Never> = .init(.none)
    var valuePublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset(){
        tipSubject.send(.none)
    }
    
    private func layout(){
        [headerView, buttonVStackView].forEach(addSubview(_:))
        
        buttonVStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(buttonVStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(buttonHStackView.snp.centerY)
        }
    }
    
    private func handleCustomTipButton(){
        let alertController: UIAlertController = {
            let alert = UIAlertController(
                title: "Enter custom tip",
                message: nil,
                preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Make it generous"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
            }
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel)
            let okAction = UIAlertAction(
                title: "OK",
                style: .default) { [weak self] _ in
                    guard let text = alert.textFields?.first?.text, let value = Int(text) else { return }
                    self?.tipSubject.send(.customPercent(value: value))
                }
            [cancelAction, okAction].forEach(alert.addAction(_:))
            return alert
        }()
        parcentViewController?.present(alertController, animated: true)
    }
    
    private func observe(){
        tipSubject.sink { [unowned self] tip in
            resetView()
            switch tip {
            case .none:
                    break
            case .tenPercent:
                tenPercentButton.backgroundColor =  ThemeColor.secondary
            case .fifteenPercent:
                fifteenPercentButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                twentyPercentButton.backgroundColor = ThemeColor.secondary
            case .customPercent(let value):
                customButton.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(
                    string: "$\(value)",
                    attributes: [.font: ThemeFont.bold(ofSize: 20)])
                text.addAttributes(
                    [.font: ThemeFont.demiBold(ofSize: 14)],
                    range: NSMakeRange(0, 1))
                customButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellable)
    }
    
    private func resetView(){
        [tenPercentButton,
         fifteenPercentButton,
         twentyPercentButton,
         customButton].forEach { $0.backgroundColor = ThemeColor.primary
        }
        
        let text = NSMutableAttributedString(
            string: "Custom tip",
            attributes: [.font: ThemeFont.bold(ofSize: 20)])
        customButton.setAttributedTitle(
            text,
            for: .normal)
    }
    
    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        let text = NSMutableAttributedString(
            string: tip.caseStringValue,
            attributes: [.font: ThemeFont.bold(ofSize: 20),
                         .foregroundColor: UIColor.white])
        text.addAttributes(
            [.font: ThemeFont.demiBold(ofSize: 14)],
            range: NSMakeRange(2, 1) )
        button.setAttributedTitle(text, for: .normal)
        return button
    }
}
