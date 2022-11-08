//
//  SegmentStore.swift
//  
//
//  Created by Nail Sharipov on 05.11.2022.
//

struct SegmentStore {
    
    private var segments: [Segment] = []
    
    @inlinable
    subscript(index: Int) -> Segment {
        get {
            segments[index]
        }
        set {
            segments[index] = newValue
        }
    }
    
    @inlinable
    mutating func put(segment: Segment) -> Int {
        let index = segments.count
        segments.append(segment)
        return index
    }
    
}
