//
//  BillInputView.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 17.09.2023.
//
import UIKit
import Combine
import CombineCocoa

class BillInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(
            topText: "Enter",
            bottomText: "your bill")
        return view
    }()
    
    private let textViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 8.0)
        return view
    }()
    
    private let currentDemolitionLabel: UILabel = {
        let label = LabelFacrory.build(
            text: "$",
            font: ThemeFont.bold(ofSize: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = ThemeFont.demiBold(ofSize: 28)
        tf.keyboardType = .decimalPad
        tf.setContentHuggingPriority(.defaultLow, for: .horizontal)
        tf.tintColor = ThemeColor.text
        tf.textColor  = ThemeColor.text
        //Add toolbar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 36))
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        let doneBotton = UIBarButtonItem(
            title: "Done",
            style: .plain ,
            target: self,
            action: #selector(doneBattonTap))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneBotton
        ]
        toolbar.isUserInteractionEnabled = true
        tf.inputAccessoryView = toolbar
        return tf
    }()
    ///Combine property
    private let billSubject: PassthroughSubject<Double, Never> = .init()
    var valuePublisher: AnyPublisher<Double, Never> {
        return billSubject.eraseToAnyPublisher()
    }
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [headerView, textViewContainer].forEach(addSubview(_:))//Дoбавляем массив обьектов
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textViewContainer.snp.centerY)
            make.width.equalTo(68)
            make.height.equalTo(24)
            make.trailing.equalTo(textViewContainer.snp.leading).offset(-24)
        }
        
        textViewContainer.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        textViewContainer.addSubview(currentDemolitionLabel)
        textViewContainer.addSubview(textField)
        
        currentDemolitionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(textViewContainer.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(currentDemolitionLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textViewContainer.snp.trailing).offset(-16)
        }
    }
    
    func reset(){
        textField.text = nil
        billSubject.send(0)
    }
    
    private func observe(){
        textField.textPublisher.sink {[unowned self] text in            billSubject.send(text?.doubleValue ?? 0)
            print("text \(String(describing: text))")
        }.store(in: &cancellable)
    }
    
    @objc func doneBattonTap(){
        textField.endEditing(true)
    }
}
