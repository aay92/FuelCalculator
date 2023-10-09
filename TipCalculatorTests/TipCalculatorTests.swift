//
//  TipCalculatorTests.swift
//  TipCalculatorTests
//
//  Created by Aleksey Alyonin on 17.09.2023.
//

import XCTest
import Combine
@testable import TipCalculator

final class TipCalculatorTests: XCTestCase {
  ///sut - sestem under test
    private var sut: CalculaterVM!
    private var cancalllbe: Set<AnyCancellable>!
    
    private var logoViewSubject: PassthroughSubject<Void, Never>!
    private var audioPlayerSubject: MockAudioPlayer!
    
    override func setUp() {
        audioPlayerSubject = .init()
        sut = .init(audioPlayerService: audioPlayerSubject)
        logoViewSubject = .init()
        cancalllbe = .init()
        
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancalllbe = nil
        audioPlayerSubject = nil
        logoViewSubject = nil
    }
    
    func testResultWithoutTipFor1Person(){
        //given
        /// bill $100.0
        /// no tip
        /// 1 person
        let bill:  Double = 100.0
        let tip:   Tip = .none
        let split: Int = 1
        
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 0)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTill, 0)
        }.store(in: &cancalllbe)
    }
    
    func testResultWithoutTipFor2Person(){
        //given
        /// bill $100.0
        /// no tip
        /// 1 person
        let bill:  Double = 100.0
        let tip:   Tip = .none
        let split: Int = 2
        
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 0)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTill, 0)
        }.store(in: &cancalllbe)
    }
    
    func testResultWithTenPercentTipFor2Person(){
        //given
        /// bill $100.0
        /// no tip
        /// 1 person
        let bill:  Double = 100.0
        let tip:   Tip = .tenPercent
        let split: Int = 2
        
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 5)
            XCTAssertEqual(result.totalBill, 110)
            XCTAssertEqual(result.totalTill, 10)
        }.store(in: &cancalllbe)
    }
    
    func testSoundPlayedAndCalculatorResultViewLogoTap(){
        //given
        let input = buildInput(bill: 100, tip: .tenPercent, split: 2)
        let output = sut.transform(input: input)
        let expectation1 = XCTestExpectation(description: "Reset calculator")
        let expectation2 = audioPlayerSubject.expectation
        //when
        output.resetCalculaterPublisher.sink { _ in
            expectation1.fulfill()
        }.store(in: &cancalllbe)
        //then
        logoViewSubject.send()
        wait(for: [expectation1, expectation2], timeout: 1.0)
    }
    
    private func buildInput(bill: Double, tip: Tip, split: Int)-> CalculaterVM.Input {
        return .init(
            billPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublisher: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewSubject.eraseToAnyPublisher())
    }
}


class MockAudioPlayer: AudioPlayerService {
    let expectation = XCTestExpectation(description: "playSound")
    func playSound() {
        expectation.fulfill()
    }
}
