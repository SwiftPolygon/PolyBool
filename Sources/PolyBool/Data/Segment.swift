//
//  Segment.swift
//  
//
//  Created by Nail Sharipov on 03.11.2022.
//

import Geom

struct Fill {
    
    var above: Bool
    var below: Bool
    var isSet: Bool
    
    @inlinable
    init(above: Bool, below: Bool, isSet: Bool = false) {
        self.above = above
        self.below = below
        self.isSet = isSet
    }
}

struct Segment {
    
    var start: Point
    var end: Point
    var myFill: Fill
    var otherFill: Fill
    
    @inlinable
    init(start: Point, end: Point, myFill: Fill = .init(above: false, below: false), otherFill: Fill = .init(above: false, below: false)) {
        self.start = start
        self.end = end
        self.myFill = myFill
        self.otherFill = otherFill
    }
    
}
