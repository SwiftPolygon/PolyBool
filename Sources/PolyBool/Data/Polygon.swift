//
//  Polygon.swift
//  
//
//  Created by Nail Sharipov on 03.11.2022.
//

import Geom

public struct Polygon {

    public let regions: [Region]
    public let inverted: Bool
    
    public init(regions: [Region] = [], isInverted: Bool = false) {
        self.regions = regions
        self.inverted = isInverted
    }

}

public extension Array where Element == Point {
    
    var polygon: Polygon {
        Polygon(regions: [Region(points: self)], isInverted: false)
    }
    
}
