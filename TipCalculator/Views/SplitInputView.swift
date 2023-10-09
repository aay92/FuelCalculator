//
//  SplitInputView.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 17.09.2023.
//
import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(
            topText: "Split",
            bottomText: "the total")
        return view
    }()
    
    private lazy var decremantButton: UIButton = {
        let button = buildButton(
            text: "-",
            corner: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value == 1 ? 1 : splitSubject.value - 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellbeles)
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = buildButton(
            text: "+",
            corner: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value + 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellbeles)
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = LabelFacrory.build(
            text: "1",
            font: ThemeFont.bold(ofSize: 20))
        label.backgroundColor = .white
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [decremantButton,
                               quantityLabel,
                               incrementButton]
        )
        stack.axis = .horizontal
        stack.spacing = 0
        return stack
    }()
    
    private let splitSubject: CurrentValueSubject<Int, Never> = .init(1)
    var valuePublisher: AnyPublisher<Int, Never> {
        return splitSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    private var cancellbeles = Set<AnyCancellable>()
    
    init(){
        super.init(frame: .zero)
        layout()
        observe()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset(){
        splitSubject.send(1)
    }
    
    private func observe(){
        splitSubject.sink { [unowned self] quantity in
            quantityLabel.text = quantity.stringValue
        }.store(in: &cancellbeles)
    }
    
    private func layout(){
        [headerView, hStackView].forEach(addSubview(_:))
        
        hStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [incrementButton, decremantButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(hStackView.snp.centerY)
            make.trailing.equalTo(hStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
        }
        
    }
    
    private func buildButton(text: String, corner: CACornerMask) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        addRaundedCorners(corners: corner, radius: 8.0)
        return button
    }
}
