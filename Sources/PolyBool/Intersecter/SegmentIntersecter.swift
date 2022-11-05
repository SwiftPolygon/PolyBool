//
//  SegmentIntersecter.swift
//  
//
//  Created by Nail Sharipov on 04.11.2022.
//

import Geom

struct SegmentIntersecter {
    
    private var intersecter: Intersecter
    
    init(geom: Geom) {
        intersecter = Intersecter(selfIntersection: false, geom: geom)
    }
    
    mutating func addRegion(region: Region) {
        // regions are a list of points:
        //  [ [0, 0], [100, 0], [50, 100] ]
        // you can add multiple regions before running calculate
        var pt1: Point = .zero
        var pt2 = region.points[region.points.count - 1]
        for i in 0..<region.points.count {
            pt1 = pt2
            pt2 = region.points[i]

            let forward = intersecter.geom.pointsCompare(pt1, pt2)
            
            // points are equal, so we have a zero-length segment
            guard forward != 0 else {
                continue // just skip it
            }

            intersecter.eventAddSegment(
              segment: Segment(
                    start: forward < 0 ? pt1 : pt2,
                    end: forward < 0 ? pt2 : pt1
              ),
              primary: true
            )
        }
    }

    mutating func calculate(segments1: [Segment], isInverted1: Bool, segments2: [Segment], isInverted2: Bool) -> [Segment] {
        // returns segments that can be used for further operations
        for segment in segments1 {
            intersecter.eventAddSegment(segment: segment, primary: true)
        }
        
        for segment in segments2 {
            intersecter.eventAddSegment(segment: segment, primary: true)
        }

        return intersecter.calculate(primaryPolyInverted: isInverted1, secondaryPolyInverted: isInverted2)
    }
}
