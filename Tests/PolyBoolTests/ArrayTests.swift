//
//  ArrayTests.swift
//  
//
//  Created by Nail Sharipov on 08.11.2022.
//

import XCTest
import Geom
@testable import PolyBool

final class ArrayTests: XCTestCase {

    private let geom = Geom(eps: 0.001)
    
    private let a = [
        Point(x: 0, y: 0),
        Point(x: 1, y: 1),
        Point(x: 2, y: 2)
    ]
    
    func test_0() throws {
        XCTAssertFalse(geom.isSame(a, [
            Point(x: 0, y: 0)
        ]))
    }
    
    func test_1() throws {
        XCTAssertTrue(geom.isSame(a, [
            Point(x: 0, y: 0),
            Point(x: 1, y: 1),
            Point(x: 2, y: 2)
        ]))
        
        XCTAssertTrue(geom.isSame(a, [
            Point(x: 0, y: 0),
            Point(x: 2, y: 2),
            Point(x: 1, y: 1)
        ]))
        
        XCTAssertTrue(geom.isSame(a, [
            Point(x: 2, y: 2),
            Point(x: 0, y: 0),
            Point(x: 1, y: 1)
        ]))
        
        XCTAssertTrue(geom.isSame(a, [
            Point(x: 2, y: 2),
            Point(x: 1, y: 1),
            Point(x: 0, y: 0)
        ]))
        
        XCTAssertTrue(geom.isSame(a, [
            Point(x: 1, y: 1),
            Point(x: 2, y: 2),
            Point(x: 0, y: 0)
        ]))
        
        XCTAssertTrue(geom.isSame(a, [
            Point(x: 1, y: 1),
            Point(x: 0, y: 0),
            Point(x: 2, y: 2)
        ]))
    }
    
    func test_2() throws {
        XCTAssertFalse(geom.isSame(a, [
            Point(x: 0, y: 0),
            Point(x: 2, y: 2),
            Point(x: 1, y: 1)
        ], anyDirection: false))
        
        XCTAssertFalse(geom.isSame(a, [
            Point(x: 0, y: 0),
            Point(x: 1, y: 1),
            Point(x: 1, y: 1)
        ]))
        
        XCTAssertFalse(geom.isSame(a, [
            Point(x: 0, y: 0),
            Point(x: 1, y: 1),
            Point(x: 2, y: 2),
            Point(x: 3, y: 3)
        ]))
    }
}
