//
//  Polygon.swift
//  
//
//  Created by Nail Sharipov on 03.11.2022.
//

public struct Polygon {

    public let regions: [Region]
    public let inverted: Bool
    
    public init(regions: [Region] = [], isInverted: Bool = false) {
        self.regions = regions
        self.inverted = isInverted
    }

}
