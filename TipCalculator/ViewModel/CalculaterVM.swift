//
//  CalculaterVM.swift
//  TipCalculator
//
//  Created by Aleksey Alyonin on 29.09.2023.
//

import UIKit
import Combine

class CalculaterVM {
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<ResultData, Never>
        let resetCalculaterPublisher: AnyPublisher<Void, Never>
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    ///sound click when tap on logo view
    private let audioPlayerService: AudioPlayerService
    init(audioPlayerService: AudioPlayerService = DefaultAudioPlayerService()){
        self.audioPlayerService = audioPlayerService
    }
    
    func transform(input: Input) -> Output {
        
        //        input.splitPublisher.sink { text in
        //            print("split :\(text)")
        //        }.store(in: &cancellable)
        //
        //        input.billPublisher.sink { text in
        //            print("bill :\(text)")
        //        }.store(in: &cancellable)
        //
        //        input.tipPublisher.sink { text in
        //            print("tip: \(text)")
        //        }.store(in: &cancellable)
        
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublisher,
            input.splitPublisher).flatMap {[unowned self] (bill, tip, split) in
                let totalTip = getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalTip / Double(split)
                
                let result = ResultData(
                    amountPerPerson: amountPerPerson,
                    totalBill: totalBill,
                    totalTill: totalTip)
                
                return Just(result)
            }.eraseToAnyPublisher()
        
        let resultCalculatorPublisher = input
            .logoViewTapPublisher
            .handleEvents(receiveSubscription: { [unowned self] _ in
                audioPlayerService.playSound()
            }).flatMap({
                return Just($0)
            }).eraseToAnyPublisher()
        
        return Output(updateViewPublisher: updateViewPublisher, resetCalculaterPublisher: resultCalculatorPublisher)
    }
    
    private func getTipAmount(bill: Double, tip: Tip)-> Double{
        switch tip {
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .customPercent(let value):
            return Double(value)
        }
    }
}
