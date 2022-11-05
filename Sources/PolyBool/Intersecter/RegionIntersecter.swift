//
//  RegionIntersecter.swift
//  
//
//  Created by Nail Sharipov on 04.11.2022.
//

import Geom

struct RegionIntersecter {
    
    private var intersecter: Intersecter
    
    init(geom: Geom) {
        intersecter = Intersecter(selfIntersection: true, geom: geom)
    }
    
    mutating func addRegion(region: Region) {
          // regions are a list of points:
          //  [ [0, 0], [100, 0], [50, 100] ]
          // you can add multiple regions before running calculate
        var pt1: Point = .zero
        var pt2 = region.points[region.points.count - 1]
        for p in region.points {
              pt1 = pt2
              pt2 = p

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

    mutating func calculate(inverted: Bool) -> [Segment] {
        intersecter.calculate(primaryPolyInverted: inverted, secondaryPolyInverted: false)
    }

  }
