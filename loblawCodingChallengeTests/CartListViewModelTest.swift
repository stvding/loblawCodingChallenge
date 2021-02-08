//
//  CartListViewModelTest.swift
//  loblawCodingChallengeTests
//
//  Created by Zhongyi Ding on 2021-02-08.
//

import XCTest
@testable import loblawCodingChallenge
import OHHTTPStubs

class CartListViewModelTest: XCTestCase {
    var viewModel: CartListViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = CartListViewModel(apiClient: LoblawApiClient.shared)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        HTTPStubs.removeAllStubs()
    }
    
    func testReceiveEmptyResult() {
        stub(condition: isMethodGET()) { _ in
            let stubPath = OHPathForFile("emptyResult.json", CartListViewModelTest.self)
            return fixture(filePath: stubPath!, status: 200, headers: nil)
        }
        
        viewModel.requestCartInfo()
        Thread.sleep(forTimeInterval: 1)
        XCTAssertTrue(viewModel.getProductCount() == 0)
    }
    
    
    func testReceiveResultWithOneProduct() {
        stub(condition: isMethodGET()) { _ in
            let stubPath = OHPathForFile("oneResult.json", CartListViewModelTest.self)
            return fixture(filePath: stubPath!, status: 200, headers: nil)
        }
        
        viewModel.requestCartInfo()
        Thread.sleep(forTimeInterval: 1)
        XCTAssertTrue(viewModel.getProductCount() == 1)
        XCTAssertTrue(viewModel.getProductName(index: 0) == "foo")
        XCTAssertTrue(viewModel.getProductImageURL(index: 0) == "bar")
        XCTAssertTrue(viewModel.getProductDetails(index: 0)?.price == "$0")
        XCTAssertTrue(viewModel.getProductDetails(index: 0)?.type == "hello")
        XCTAssertTrue(viewModel.getProductDetails(index: 0)?.code == "123")
    }
    

    func testReceiveResultWithFiveProduct() {
        stub(condition: isMethodGET()) { _ in
            let stubPath = OHPathForFile("fiveResults.json", CartListViewModelTest.self)
            return fixture(filePath: stubPath!, status: 200, headers: nil)
        }
        
        viewModel.requestCartInfo()
        Thread.sleep(forTimeInterval: 1)
        XCTAssertTrue(viewModel.getProductCount() == 5)
        XCTAssertTrue(viewModel.getProductName(index: 4) == "p5")
        XCTAssertTrue(viewModel.getProductName(index: 1) == "p2")
        XCTAssertTrue(viewModel.getProductImageURL(index: 2) == "i3")
        XCTAssertTrue(viewModel.getProductDetails(index: 3)?.price == "$4")
        XCTAssertTrue(viewModel.getProductDetails(index: 3)?.type == "t4")
        XCTAssertTrue(viewModel.getProductDetails(index: 0)?.code == "1")
    }
    
    func testArrayOutOfBounds() {
        stub(condition: isMethodGET()) { _ in
            let stubPath = OHPathForFile("fiveResults.json", CartListViewModelTest.self)
            return fixture(filePath: stubPath!, status: 200, headers: nil)
        }
        
        viewModel.requestCartInfo()
        Thread.sleep(forTimeInterval: 1)
        XCTAssertTrue(viewModel.getProductName(index: 5) == "")
        XCTAssertTrue(viewModel.getProductImageURL(index: 5) == "")
        XCTAssertTrue(viewModel.getProductDetails(index: 5) == nil)
    }
}
