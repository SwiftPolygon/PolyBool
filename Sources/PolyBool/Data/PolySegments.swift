//
//  PolySegments.swift
//  
//
//  Created by Nail Sharipov on 03.11.2022.
//

struct PolySegments {
    
    let isInverted: Bool
    let segments: [Segment]
    
    init(isInverted: Bool, segments: [Segment]) {
        self.isInverted = isInverted
        self.segments = segments
    }
}
