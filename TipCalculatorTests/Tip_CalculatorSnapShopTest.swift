//
//  Tip_CalculatorSnapShopTest.swift
//  TipCalculatorTests
//
//  Created by Aleksey Alyonin on 09.10.2023.
//
import UIKit
import XCTest
import SnapshotTesting

@testable import TipCalculator

final class Tip_CalculatorSnapShopTest: XCTestCase {

    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func testLogoView(){
        //give
        let size = CGSize(width: screenWidth, height: 48)
        //when
        let view = LogoView()
        //then
        assertSnapshots(of: view, as: [.image(size: size)])
    }
    
    func testInitialResultView(){
        //give
        let size = CGSize(width: screenWidth, height: 224)
        //when
        let view = ResultView()
        //then
        assertSnapshots(of: view, as: [.image(size: size)])
    }
    
    func testInitialBillInputView(){
        //give
        let size = CGSize(width: screenWidth, height: 56)
        //when
        let view = BillInputView()
        //then
        assertSnapshots(of: view, as: [.image(size: size)])
    }
    
    func testInitialTipInputView(){
        //give
        let size = CGSize(width: screenWidth, height: 56+56+16)
        //when
        let view = TipInputView()
        //then
        assertSnapshots(of: view, as: [.image(size: size)])
    }
    
    func testInitialSplitInputView(){
        //give
        let size = CGSize(width: screenWidth, height: 56)
        //when
        let view = SplitInputView()
        //then
        assertSnapshots(of: view, as: [.image(size: size)])
    }
}
