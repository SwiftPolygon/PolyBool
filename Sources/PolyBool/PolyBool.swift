//
//  PolyBool .swift
//
//
//  Created by Nail Sharipov on 03.11.2022.
//

import Geom

struct PolyBool {

    private let geom: Geom
    
    init(geom: Geom) {
        self.geom = geom
    }
    
    func segmentChainer(segments: [Segment]) -> [Region] {
        
        var regions = [Region]()
        var chains = [[Point]]()
        
        for seg in segments {

            let pt1 = seg.start
            let pt2 = seg.end
            
            
            guard !geom.isEqual(a: pt1, b: pt2) else {
                 debugPrint("PolyBool: Warning: Zero-length segment detected; your epsilon is probably too small or too large")
                 continue
            }

            // search for two chains that this segment matches
            var match = [
                Matcher(index: 0, matchesHead: false, matchesPt1: false),
                Matcher(index: 0, matchesHead: false, matchesPt1: false)
            ]
            var nextMatch = 0

            for i in 0..<chains.count {
                let chain = chains[i]
                let head = chain[0]
                let tail = chain[chain.count - 1]
                if geom.isEqual(a: head, b: pt1) {
                    match[nextMatch] = Matcher(
                        index: i,
                        matchesHead: true,
                        matchesPt1: true
                    )
                    if nextMatch == 0 {
                        nextMatch = 1
                    } else {
                        nextMatch = -1
                        break
                    }
                } else if geom.isEqual(a: head, b: pt2) {
                    if geom.isEqual(a: head, b: pt1) {
                        match[nextMatch] = Matcher(
                            index: i,
                            matchesHead: true,
                            matchesPt1: false
                        )
                        
                        if nextMatch == 0 {
                            nextMatch = 1
                        } else {
                            nextMatch = -1
                            break
                        }
                    } else if geom.isEqual(a: tail, b: pt1) {
                        match[nextMatch] = Matcher(
                            index: i,
                            matchesHead: false,
                            matchesPt1: true
                        )
                        
                        if nextMatch == 0 {
                            nextMatch = 1
                        } else {
                            nextMatch = -1
                            break
                        }
                    } else if geom.isEqual(a: tail, b: pt2) {
                        match[nextMatch] = Matcher(
                            index: i,
                            matchesHead: false,
                            matchesPt1: false
                        )
                        
                        if nextMatch == 0 {
                            nextMatch = 1
                        } else {
                            nextMatch = -1
                            break
                        }
                    }
                }
            }
                
            guard nextMatch != 0 else {
                // we didn't match anything, so create a new chain
                chains.append([pt1, pt2])
                continue
            }
            
            let m0 = match[0]
            let m1 = match[1]
            
            if nextMatch == 1 {
                // we matched a single chain
                
                // add the other point to the apporpriate end, and check to see if we've closed the
                // chain into a loop
                                
                let index = m0.index
                let pt = m0.matchesPt1 ? pt2 : pt1 // if we matched pt1, then we add pt2, etc
                let addToHead = m0.matchesHead // if we matched at head, then add to the head
                
                var chain = chains[index]
                var grow = addToHead ? chain[0] : chain[chain.count - 1]
                let grow2 = addToHead ? chain[1] : chain[chain.count - 2]
                let oppo = addToHead ? chain[chain.count - 1] : chain[0]
                let oppo2 = addToHead ? chain[chain.count - 2] : chain[1]
                
                if geom.arePointsCollinear(a: grow2, b: grow, c: pt) {
                    // grow isn't needed because it's directly between grow2 and pt:
                    // grow2 ---grow---> pt
                    if addToHead {
                        chain.removeFirst()
                    } else {
                        chain.removeLast()
                    }
                    grow = grow2 // old grow is gone... new grow is what grow2 was
                }
                
                if geom.isEqual(a: oppo, b: pt) {
                    // we're closing the loop, so remove chain from chains
                    chains.remove(at: index)
                    
                    if geom.arePointsCollinear(a: oppo2, b: oppo, c: grow) {
                        // oppo isn't needed because it's directly between oppo2 and grow:
                        // oppo2 ---oppo--->grow
                        if addToHead {
                            chain.removeLast()
                        } else {
                            chain.removeFirst()
                        }
                    }
                
                    // chains[index] = chain !!!!
                    
                    // we have a closed chain!
                    regions.append(Region(points: chain))
                    continue
                }
                
                // not closing a loop, so just add it to the apporpriate side
                if addToHead {
                    chain.insert(pt, at: 0)
                } else {
                    chain.append(pt)
                }
                
                chains[index] = chain
                
                continue
            }
            
            // otherwise, we matched two chains, so we need to combine those chains together

            let f = m0.index
            let s = m1.index

            let reverseF = chains[f].count < chains[s].count // reverse the shorter chain, if needed
            if m0.matchesHead {
                if m1.matchesHead {
                    if reverseF {
                        // <<<< F <<<< --- >>>> S >>>>
                        chains[f].reverse()
                        // >>>> F >>>> --- >>>> S >>>>
                        chains.appendChain(index1: f, index2: s, geom: geom)
                    } else {
                        // <<<< F <<<< --- >>>> S >>>>
                        chains[s].reverse()
                        // <<<< F <<<< --- <<<< S <<<<   logically same as:
                        // >>>> S >>>> --- >>>> F >>>>
                        chains.appendChain(index1: s, index2: f, geom: geom)
                    }
                } else {
                    // <<<< F <<<< --- <<<< S <<<<   logically same as:
                    // >>>> S >>>> --- >>>> F >>>>
                    chains.appendChain(index1: s, index2: f, geom: geom)
                }
            } else {
                if m1.matchesHead {
                    // >>>> F >>>> --- >>>> S >>>>
                    chains.appendChain(index1: f, index2: s, geom: geom)
                } else {
                    if reverseF {
                        // >>>> F >>>> --- <<<< S <<<<
                        chains[f].reverse()
                        // <<<< F <<<< --- <<<< S <<<<   logically same as:
                        // >>>> S >>>> --- >>>> F >>>>
                        chains.appendChain(index1: s, index2: f, geom: geom)
                    } else {
                        // >>>> F >>>> --- <<<< S <<<<
                        chains[s].reverse()
                        // >>>> F >>>> --- >>>> S >>>>
                        chains.appendChain(index1: f, index2: s, geom: geom)
                    }
                }
            }
        }

         return regions
     }

    @inlinable
    public func segments(poly: Polygon) -> PolySegments {
        var i = RegionIntersecter(geom: geom)
        for region in poly.regions {
            i.addRegion(region: region)
        }
        
        let segments = i.calculate(inverted: poly.inverted)
        let isInverted = poly.inverted

        return PolySegments(isInverted: isInverted, segments: segments)
     }

    @inlinable
    func combine(segments1: PolySegments, segments2: PolySegments) -> CombinedPolySegments {
        var i = SegmentIntersecter(geom: geom)
        
        let combined = i.calculate(
            segments1: segments1.segments,
            isInverted1: segments1.isInverted,
            segments2: segments2.segments,
            isInverted2: segments2.isInverted
        )
        
        return CombinedPolySegments(
            isInverted1: segments1.isInverted,
            isInverted2: segments2.isInverted,
            combined: combined
        )
     }


    @inlinable
    func polygon(polySegments: PolySegments, segmentStore: SegmentStore) -> Polygon {
        let regions = self.segmentChainer(segments: polySegments.segments)
        return Polygon(regions: regions, isInverted: polySegments.isInverted)
    }

}

private extension Array where Element == [Point] {

    mutating func appendChain(index1: Int, index2: Int, geom: Geom) {
        // index1 gets index2 appended to it, and index2 is removed
        var chain1 = self[index1]
        var chain2 = self[index2]
        var tail = chain1[chain1.count - 1]
        let tail2 = chain1[chain1.count - 2]
        let head = chain2[0]
        let head2 = chain2[1]
        
        if geom.arePointsCollinear(a: tail2, b: tail, c: head) {
            // tail isn't needed because it's directly between tail2 and head
            // tail2 ---tail---> head
            chain1.removeLast()
            tail = tail2 // old tail is gone... new tail is what tail2 was
        }
        
        if geom.arePointsCollinear(a: tail, b: head, c: head2) {
            // head isn't needed because it's directly between tail and head2
            // tail ---head---> head2
            chain2.removeFirst()
        }
        
        chain1.append(contentsOf: chain2)
        
        self[index1] = chain1
        self.remove(at: index2)
    }
}
