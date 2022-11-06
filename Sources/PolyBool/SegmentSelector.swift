//
//  SegmentSelector.swift
//  
//
//  Created by Nail Sharipov on 03.11.2022.
//

import Geom

public struct SegmentSelector {
    
    private let polyBool: PolyBool
    
    public init(geom: Geom) {
        polyBool = PolyBool(geom: geom)
    }
    
    public func union(segments: [Segment]) -> [Segment] {
        self.select(segments: segments, selection: [
            0, 2, 1, 0,
            2, 2, 0, 0,
            1, 0, 1, 0,
            0, 0, 0, 0
        ])
    }

    public func union(first: Polygon, second: Polygon) -> Polygon {
        let firstPolygonRegions = polyBool.segments(poly: first)
        let secondPolygonRegions = polyBool.segments(poly: second)
        let combinedSegments = polyBool.combine(segments1: firstPolygonRegions, segments2: secondPolygonRegions)

        let union = self.select(segments: combinedSegments.combined, selection: [
            0, 2, 1, 0,
            2, 2, 0, 0,
            1, 0, 1, 0,
            0, 0, 0, 0
        ])

        return Polygon(
            regions: polyBool.segmentChainer(segments: union),
            isInverted: first.inverted || second.inverted
        )
    }

    public func intersect(segments: [Segment]) -> [Segment] {
        self.select(segments: segments, selection: [
            0, 0, 0, 0,
            0, 2, 0, 2,
            0, 0, 1, 1,
            0, 2, 1, 0
        ])
    }

    public func intersect(first: Polygon, second: Polygon) -> Polygon {
        let firstPolygonRegions = polyBool.segments(poly: first)
        let secondPolygonRegions = polyBool.segments(poly: second)
        let combinedSegments = polyBool.combine(segments1: firstPolygonRegions, segments2: secondPolygonRegions)

        let intersection = self.select(segments: combinedSegments.combined, selection: [
            0, 0, 0, 0,
            0, 2, 0, 2,
            0, 0, 1, 1,
            0, 2, 1, 0
        ])
        
        let regions = polyBool.segmentChainer(segments: intersection)
        
        return Polygon(
            regions: regions,
            isInverted: first.inverted && second.inverted
        )
    }

    func difference(combined: CombinedPolySegments) -> PolySegments {
        let isInverted = !combined.isInverted1 && combined.isInverted2
        
        let segments = self.select(segments: combined.combined, selection: [
            0, 0, 0, 0,
            2, 0, 2, 0,
            1, 1, 0, 0,
            0, 1, 2, 0
        ])

        return PolySegments(isInverted: isInverted, segments: segments)
    }
    
    func difference(first: Polygon, second: Polygon) -> Polygon {
        let firstPolygonRegions = polyBool.segments(poly: first)
        let secondPolygonRegions = polyBool.segments(poly: second)
        let combinedSegments = polyBool.combine(segments1: firstPolygonRegions, segments2: secondPolygonRegions)

        let difference = self.select(segments: combinedSegments.combined, selection: [
                0, 0, 0, 0,
                2, 0, 2, 0,
                1, 1, 0, 0,
                0, 1, 2, 0
        ])

        let regions = polyBool.segmentChainer(segments: difference)
        
        return Polygon(
            regions: regions,
            isInverted: first.inverted && !second.inverted
        )
    }
    
    public func differenceRev(segments: [Segment]) -> [Segment] {
        self.select(segments: segments, selection: [
            0, 2, 1, 0,
            0, 0, 1, 1,
            0, 2, 0, 2,
            0, 0, 0, 0
        ])
    }

    public func differenceRev(first: Polygon, second: Polygon) -> Polygon {
        let firstPolygonRegions = polyBool.segments(poly: first)
        let secondPolygonRegions = polyBool.segments(poly: second)
        let combinedSegments = polyBool.combine(segments1: firstPolygonRegions, segments2: secondPolygonRegions)

        let difference = self.select(segments: combinedSegments.combined, selection: [
            0, 2, 1, 0,
            0, 0, 1, 1,
            0, 2, 0, 2,
            0, 0, 0, 0
        ])
            
        let regions = polyBool.segmentChainer(segments: difference)

        return Polygon(
            regions: regions,
            isInverted: !first.inverted && second.inverted
        )
    }
    
    public func xor(segments: [Segment]) -> [Segment] {
        self.select(segments: segments, selection: [
            0, 2, 1, 0,
            2, 0, 0, 1,
            1, 0, 0, 2,
            0, 1, 2, 0
        ])
    }
    
    public func xor(first: Polygon, second: Polygon) -> Polygon {
        let firstPolygonRegions = polyBool.segments(poly: first)
        let secondPolygonRegions = polyBool.segments(poly: second)
        let combinedSegments = polyBool.combine(segments1: firstPolygonRegions, segments2: secondPolygonRegions)

        let xor = self.select(segments: combinedSegments.combined, selection: [
            0, 2, 1, 0,
            2, 0, 0, 1,
            1, 0, 0, 2,
            0, 1, 2, 0
        ])

        let regions = polyBool.segmentChainer(segments: xor)
        
        return Polygon(
            regions: regions,
            isInverted: first.inverted != second.inverted
        )
    }
    
    private func select(segments: [Segment], selection: [Int]) -> [Segment] {
        var result = [Segment]()

        for segment in segments {
            let index =
            (segment.myFill.above ? 8 : 0) +
            (segment.myFill.below ? 4 : 0) +
            (segment.otherFill.isSet && segment.otherFill.above ? 2 : 0) +
            (segment.otherFill.isSet && segment.otherFill.below ? 1 : 0)

            if selection[index] != 0 {
                result.append(
                    Segment(
                        start: segment.start,
                        end: segment.end,
                        myFill: Fill(above: selection[index] == 2, below: selection[index] == 1)
                    )
                )
            }
        }

        return result
    }
}
