//
//  ResultFoundationCallbackHelperTests.swift
//  
//
//  Created by Eric DeLabar on 11/17/23.
//

import XCTest

@testable import BespokeTesting
@testable import SIArchitecture

final class ResultFoundationCallbackHelperTests: XCTestCase {

    func testSuccess() throws {
        
        switch Result<String, TestError>(success: "Success", failure: nil) {
        case .success(let value):
            XCTAssertEqual(value, "Success")
        case .failure:
            XCTFail()
        }
        
    }
    
    func testFailure() throws {
        
        XCTAssertTrue(Result<String, TestError>(success: nil, failure: TestError()).isFailure)
        
    }

}
