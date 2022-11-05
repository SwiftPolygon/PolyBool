//
//  Segment.swift
//  
//
//  Created by Nail Sharipov on 03.11.2022.
//

import Geom

public struct Fill {
    
    public internal (set) var above: Bool
    public internal (set) var below: Bool
    public internal (set) var isSet: Bool
    
    public init(above: Bool, below: Bool, isSet: Bool = false) {
        self.above = above
        self.below = below
        self.isSet = isSet
    }
}

public struct Segment {
    
    public internal (set) var start: Point
    public internal (set) var end: Point
    public internal (set) var myFill: Fill
    public internal (set) var otherFill: Fill
    
    public init(start: Point, end: Point, myFill: Fill = .init(above: false, below: false), otherFill: Fill = .init(above: false, below: false)) {
        self.start = start
        self.end = end
        self.myFill = myFill
        self.otherFill = otherFill
    }
    
}
