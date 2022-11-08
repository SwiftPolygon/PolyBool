import Geom
import XCTest

@testable import PolyBool

final class IntersectTests: XCTestCase {
    
    private let geom = Geom(eps: 0.01)
    private let selector = SegmentSelector()

    func test_0() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:   0, y:  20),
                Point(x:  20, y:  20),
                Point(x:  20, y:   0),
                Point(x:   0, y:   0)
            ].polygon
        )
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y:  10),
                    Point(x:  10, y:  10),
                    Point(x:  10, y:   0),
                    Point(x:   0, y:   0)
                ],
                polygon.regions.first?.points ?? []
            )
        )
    }
    
    func test_1() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x: -20, y:  20),
                Point(x:   0, y:  20),
                Point(x:   0, y:   0),
                Point(x: -20, y:   0)
            ].polygon
        )
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x: -10, y:  10),
                    Point(x:   0, y:  10),
                    Point(x:   0, y:   0),
                    Point(x: -10, y:   0)
                ],
                polygon.regions.first?.points ?? []
            )
        )
    }
    
    func test_2() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x: -20, y: -20),
                Point(x: -20, y:   0),
                Point(x:   0, y:   0),
                Point(x:   0, y: -20)
            ].polygon
        )
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x: -10, y:   0),
                    Point(x:   0, y:   0),
                    Point(x:   0, y: -10),
                    Point(x: -10, y: -10)
                ],
                polygon.regions.first?.points ?? []
            )
        )
    }
    
    func test_3() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x: -20, y: -20),
                Point(x: -20, y:   0),
                Point(x:   0, y:   0),
                Point(x:   0, y: -20)
            ].polygon
        )
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x: -10, y:   0),
                    Point(x:   0, y:   0),
                    Point(x:   0, y: -10),
                    Point(x: -10, y: -10)
                ],
                polygon.regions.first?.points ?? []
            )
        )
    }
    
    func test_4() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:   0, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y:   0)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y:  10),
                    Point(x:  10, y:   0),
                    Point(x:  10, y:  10)
                ],
                points
            )
        )
    }
    
    func test_5() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x: -10, y:   0),
                Point(x: -10, y:  10),
                Point(x:   0, y:  10)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y:  10),
                    Point(x: -10, y:  10),
                    Point(x: -10, y:   0)
                ],
                points
            )
        )
    }
    
    func test_6() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:   0, y: -10),
                Point(x: -10, y: -10),
                Point(x: -10, y:   0)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y: -10),
                    Point(x: -10, y: -10),
                    Point(x: -10, y:   0)
                ],
                points
            )
        )
    }
    
    func test_7() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:  10, y: -10),
                Point(x:   0, y: -10),
                Point(x:  10, y:   0)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:  10, y: -10),
                    Point(x:   0, y: -10),
                    Point(x:  10, y:   0)
                ],
                points
            )
        )
    }
    
    func test_8() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:  10, y: -2.5),
                Point(x:   0, y: -10),
                Point(x: -10, y:  10)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:  10, y: -2.5),
                    Point(x:   0, y: -10),
                    Point(x: -10, y:  10)
                ],
                points
            )
        )
    }
    
    func test_9() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:   0, y: -10),
                Point(x: -10, y:   0),
                Point(x:  10, y:  10)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y: -10),
                    Point(x: -10, y:   0),
                    Point(x:  10, y:  10)
                ],
                points
            )
        )
    }
    
    func test_10() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x: -10, y:   0),
                Point(x:   0, y:  10),
                Point(x:  10, y: -10)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x: -10, y:   0),
                    Point(x:   0, y:  10),
                    Point(x:  10, y: -10)
                ],
                points
            )
        )
    }
    
    func test_11() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:   0, y:  10),
                Point(x:  10, y:   0),
                Point(x: -10, y: -10)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y:  10),
                    Point(x:  10, y:   0),
                    Point(x: -10, y: -10)
                ],
                points
            )
        )
    }
    
    func test_12() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:   0, y:  10),
                Point(x:  10, y:   0),
                Point(x:   0, y: -10),
                Point(x: -10, y:   0)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y:  10),
                    Point(x:  10, y:   0),
                    Point(x:   0, y: -10),
                    Point(x: -10, y:   0)
                ],
                points
            )
        )
    }
    
    func test_13() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:   0, y:   5),
                Point(x:   5, y:   0),
                Point(x:   0, y:  -5),
                Point(x:  -5, y:   0)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y:   5),
                    Point(x:   5, y:   0),
                    Point(x:   0, y:  -5),
                    Point(x:  -5, y:   0)
                ],
                points
            )
        )
    }
    
    func test_14() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:  -5, y:   5),
                Point(x:   5, y:   5),
                Point(x:   5, y:  -5),
                Point(x:  -5, y:  -5)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y:   5),
                    Point(x:   5, y:   0),
                    Point(x:   0, y:  -5),
                    Point(x:  -5, y:   0)
                ],
                points
            )
        )
    }
    
    func test_15() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x: -15, y:  15),
                Point(x:  15, y:  15),
                Point(x:  15, y: -15),
                Point(x: -15, y: -15)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x: -10, y:  10),
                    Point(x:  10, y:  10),
                    Point(x:  10, y: -10),
                    Point(x: -10, y: -10)
                ],
                points
            )
        )
    }
    
    func test_16() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x: -10, y:  10),
                Point(x:   0, y:  10),
                Point(x:  10, y:   0),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x: -10, y:  10),
                    Point(x:   0, y:  10),
                    Point(x:  10, y:   0),
                    Point(x:  10, y: -10),
                    Point(x: -10, y: -10)
                ],
                points
            )
        )
    }
    
    func test_17() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x:   0, y: -10),
                Point(x: -10, y:   0)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x: -10, y:  10),
                    Point(x:  10, y:  10),
                    Point(x:  10, y: -10),
                    Point(x:   0, y: -10),
                    Point(x: -10, y:   0)
                ],
                points
            )
        )
    }
    
    func test_18() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:   0, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10),
                Point(x: -10, y:   0)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y:  10),
                    Point(x:  10, y:  10),
                    Point(x:  10, y: -10),
                    Point(x: -10, y: -10),
                    Point(x: -10, y:   0)
                ],
                points
            )
        )
    }
    
    func test_19() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x:   0, y:  10),
                Point(x:  10, y:   0),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10),
                Point(x: -10, y:  10)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x:   0, y:  10),
                    Point(x:  10, y:   0),
                    Point(x:  10, y: -10),
                    Point(x: -10, y: -10),
                    Point(x: -10, y:  10)
                ],
                points
            )
        )
    }
    
    func test_20() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x: -15, y:  -5),
                Point(x: -15, y:   5),
                Point(x:  15, y:   5),
                Point(x:  15, y:  -5)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x: -10, y:  -5),
                    Point(x: -10, y:   5),
                    Point(x:  10, y:   5),
                    Point(x:  10, y:  -5)
                ],
                points
            )
        )
    }
    
    func test_21() throws {
        let polygon = selector.intersect(
            first: [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ].polygon,
            second: [
                Point(x: -15, y: -10),
                Point(x: -15, y:  10),
                Point(x:  15, y:  10),
                Point(x:  15, y: -10)
            ].polygon
        )

        let points = polygon.regions.first?.points ?? []
        
        XCTAssertTrue(
            geom.isSame(
                [
                    Point(x: -10, y:  10),
                    Point(x:  10, y:  10),
                    Point(x:  10, y: -10),
                    Point(x: -10, y: -10)
                ],
                points
            )
        )
    }
    
    
}
