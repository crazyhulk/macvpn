//
//  MacVpnTests.swift
//  MacVpnTests
//
//  Created by 朱熙 on 2019/8/29.
//  Copyright © 2019 朱熙. All rights reserved.
//

import XCTest
@testable import PacketTunnel

class MacVpnTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCustomWhiteList()  {
        let p = PacketTunnelProvider()
        
        XCTAssert(p.parseIPString(addessStr: "10").first?.destinationAddress == "10.0.0.0")
        XCTAssert(p.parseIPString(addessStr: "10/8").first?.destinationSubnetMask == "255.0.0.0")
        XCTAssert(p.parseIPString(addessStr: "10/9").first?.destinationSubnetMask == "255.128.0.0")  
    }

}
