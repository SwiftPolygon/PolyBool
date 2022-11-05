//
//  PolySegments.swift
//  
//
//  Created by Nail Sharipov on 03.11.2022.
//

public struct PolySegments {
    
    public internal (set) var isInverted: Bool
    public internal (set) var segments: [Segment]
    
    public init(isInverted: Bool, segments: [Segment]) {
        self.isInverted = isInverted
        self.segments = segments
    }
}
