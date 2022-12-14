//
//  Intersector.swift
//  
//
//  Created by Nail Sharipov on 03.11.2022.
//

import Geom

private struct Transition {
    let after: Int
    let before: Int
}

struct Intersector {
    
    let geom: Geom
    private var segmentStore = SegmentStore()
    private let selfIntersection: Bool
    private var eventRoot = LinkedList<Node>(empty: .empty)
    
    @inlinable
    init(selfIntersection: Bool, geom: Geom, eventRoot: LinkedList<Node> = LinkedList<Node>(empty: .empty)) {
        self.selfIntersection = selfIntersection
        self.geom = geom
        self.eventRoot = eventRoot
    }
    
    @inlinable
    mutating func eventAdd(segment: Segment, primary: Bool) {
        let seg = segmentStore.put(segment: segment)
        let evStartIndex = self.eventAddSegmentStart(segment: segment, index: seg, primary: primary)
        self.eventAddSegmentEnd(evStart: evStartIndex, segemnet: segment, index: seg, primary: primary)
    }
    
    private mutating func eventAddSegmentEnd(evStart evStartIndex: Int, segemnet s: Segment, index i: Int, primary: Bool) {
        var evStart = eventRoot[evStartIndex]
        
        let evEnd = Node(
            status: -1,
            other: evStartIndex,
            isStart: false,
            pt: s.end,
            seg: i,
            primary: primary
        )
        
        let evItem = eventRoot.create(value: evEnd)
        
        evStart.value.other = evItem.index
        eventRoot[evStartIndex] = evStart
        
        self.eventAdd(ev: evItem, otherPt: evStart.value.pt)
    }
    
    private mutating func eventAddSegmentStart(segment s: Segment, index i: Int, primary: Bool) -> Int {
        let evStart = Node(
            status: -1,
            other: -1,
            isStart: true,
            pt: s.start,
            seg: i,
            primary: primary
        )
        
        let evItem = eventRoot.create(value: evStart)
        self.eventAdd(ev: evItem, otherPt: s.end)

        return evItem.index
    }
    
    private mutating func eventAdd(ev evItem: LinkedList<Node>.Item<Node>, otherPt: Point) {
        let ev = evItem.value
        eventRoot.insertBefore(item: evItem) { here, other in
            // should ev be inserted before here?
            let comp = Self.eventCompare(
                p1IsStart: ev.isStart,
                p11: ev.pt,
                p12: otherPt,
                p2IsStart: here.isStart,
                p21: here.pt,
                p22: other.pt,
                geom: geom
            )
            return comp < 0
        }
    }
    
    private static func eventCompare(p1IsStart: Bool, p11: Point, p12: Point, p2IsStart: Bool, p21: Point, p22: Point, geom: Geom) -> Int {
        
        // compare the selected points first
        let comp = geom.pointsCompare(p11, p21)
        
        guard comp == 0 else {
            return comp
        }
        
        // the selected points are the same
        
        guard !geom.isSamePoints(p12, p22) else { // if the non-selected points are the same too...
            return 0 // then the segments are equal
        }
        
        
        guard p1IsStart == p2IsStart else { // if one is a start and the other isn"t...
            return p1IsStart ? 1 : -1 // favor the one that isn"t the start
        }
        
        // otherwise, we"ll have to calculate which one is below the other manually
        let flag = geom.pointAboveOrOnLine(
            p12,
            p2IsStart ? p21 : p22, // order matters
            p2IsStart ? p22 : p21
        )
        
        return flag ? 1 : -1
    }

    private mutating func eventUpdateEnd(ev evIndex: Int, end: Point) {
        // slides an end backwards
        //   (start)------------(end)    to:
        //   (start)---(end)
        
        let ev = eventRoot[evIndex].value
        var other = eventRoot[ev.other].value
        
        eventRoot.unlink(index: ev.other)
        
        segmentStore[ev.seg].end = end

        other.pt = end
        eventRoot[ev.other].value = other

        let otherItem = eventRoot[ev.other]
        
        eventAdd(ev: otherItem, otherPt: ev.pt)
    }
    
    private mutating func eventDivide(ev evIndex: Int, pt: Point) {
        let ev = eventRoot[evIndex].value
        
        let s = segmentStore[ev.seg]
        
        let newSeg = Segment(
            start: pt,
            end: s.end,
            myFill: s.myFill
        )
        
        let ns = segmentStore.put(segment: newSeg)
        self.eventUpdateEnd(ev: evIndex, end: pt)
        let evStartIndex = self.eventAddSegmentStart(segment: newSeg, index: ns, primary: ev.primary)
        self.eventAddSegmentEnd(evStart: evStartIndex, segemnet: newSeg, index: ns, primary: ev.primary)
    }

    private mutating func checkIntersection(ev1 ev1Index: Int, ev2 ev2Index: Int) -> Bool {
        // returns the segment equal to ev1, or false if nothing equal
        
        let seg1 = eventRoot[ev1Index].value.seg
        let seg2 = eventRoot[ev2Index].value.seg
        
        let s1 = segmentStore[seg1]
        let s2 = segmentStore[seg2]
        
        let a1 = s1.start
        let a2 = s1.end
        let b1 = s2.start
        let b2 = s2.end
        
        let i = geom.isCross(a1, a2, b1, b2)
        
        if !i.isCross {
            // segments are parallel or coincident
            
            // if points aren"t collinear, then the segments are parallel, so no intersections
            guard geom.arePointsCollinear(a1, a2, b1) else {
                return false
            }
            
            // otherwise, segments are on top of each other somehow (aka coincident)
            
            guard !(geom.isSamePoints(a1, b2) || geom.isSamePoints(a2, b1)) else {
                return false // segments touch at endpoints... no intersection
            }
            
            let a1EquB1 = geom.isSamePoints(a1, b1)
            let a2EquB2 = geom.isSamePoints(a2, b2)
            
            guard !(a1EquB1 && a2EquB2) else {
                return true // segments are exactly equal
            }
            
            let a1Between = !a1EquB1 && geom.pointBetween(a1, b1, b2)
            let a2Between = !a2EquB2 && geom.pointBetween(a2, b1, b2)
            
            if a1EquB1 {
                if a2Between {
                    //  (a1)---(a2)
                    //  (b1)----------(b2)
                    eventDivide(ev: ev2Index, pt: a2)
                } else {
                    //  (a1)----------(a2)
                    //  (b1)---(b2)
                    eventDivide(ev: ev1Index, pt: b2)
                }
                return true
            } else if (a1Between) {
                if !a2EquB2 {
                    // make a2 equal to b2
                    if a2Between {
                        //         (a1)---(a2)
                        //  (b1)-----------------(b2)
                        eventDivide(ev: ev2Index, pt: a2)
                    } else {
                        //         (a1)----------(a2)
                        //  (b1)----------(b2)
                        eventDivide(ev: ev1Index, pt: b2)
                    }
                }
                
                //         (a1)---(a2)
                //  (b1)----------(b2)
                eventDivide(ev: ev2Index, pt: a1)
            }
        } else {
            // otherwise, lines intersect at i.pt, which may or may not be between the endpoints
            
            // is A divided between its endpoints? (exclusive)
            if i.a == 0 {
                if i.b == -1 { // yes, at exactly b1
                    eventDivide(ev: ev1Index, pt: b1)
                } else if i.b == 0 { // yes, somewhere between B"s endpoints
                    eventDivide(ev: ev1Index, pt: i.point)
                } else if i.b == 1 { // yes, at exactly b2
                    eventDivide(ev: ev1Index, pt: b2)
                }
            }
            
            // is B divided between its endpoints? (exclusive)
            if i.b == 0 {
                if i.a == -1 { // yes, at exactly a1
                    eventDivide(ev: ev2Index, pt: a1)
                } else if i.a == 0 { // yes, somewhere between A"s endpoints (exclusive)
                    eventDivide(ev: ev2Index, pt: i.point)
                } else if i.a == 1 { // yes, at exactly a2
                    eventDivide(ev: ev2Index, pt: a2)
                }
            }
        }
        
        return false
    }
    
    private mutating func checkBothIntersections(above: Int, ev: Int, below: Int) -> Int {
        if above >= 0 && checkIntersection(ev1: ev, ev2: above) {
            return above
        }
        
        if below >= 0 && checkIntersection(ev1: ev, ev2: below) {
            return below
        }
        
        return -1
    }
    
    @inlinable
    mutating func calculate(primaryPolyInverted: Bool, secondaryPolyInverted: Bool) -> [Segment] {
        // if selfIntersection is true then there is no secondary polygon, so that isn"t used
        
        //
        // status logic
        //
        
        var statusRoot = LinkedList<Int>(empty: -1)
        
        
        
        //
        // main event loop
        //
        var segIndices = [Int]()
        while !eventRoot.isEmpty {
            
            let evItem = eventRoot.head
            var ev = evItem.value
            
            if ev.isStart {
                var s = segmentStore[ev.seg]
                
                let surrounding = statusRoot.findTransition(
                    eventList: eventRoot,
                    segmentStore: segmentStore,
                    s1: s,
                    geom: geom
                ) //(statusRoot: &statusRoot, ev: ev)
                
                let aboveIndex = surrounding.before >= 0 ? statusRoot[surrounding.before].value : -1
                let belowIndex = surrounding.after >= 0 ? statusRoot[surrounding.after].value : -1
                
                // Modify!
                let eveIndex = checkBothIntersections(above: aboveIndex, ev: evItem.index, below: belowIndex)

                ev = eventRoot[evItem.index].value
                s = segmentStore[ev.seg]
                
                if eveIndex >= 0 {
                    // ev and eve are equal
                    // we"ll keep eve and throw away ev
                    
                    // merge ev.seg"s fill information into eve.seg
                    
                    if selfIntersection {
                        let toggle: Bool // are we a toggling edge?
                        if !s.myFill.isSet {
                            toggle = true
                        } else {
                            toggle = s.myFill.above != s.myFill.below
                        }
                        
                        // merge two segments that belong to the same polygon
                        // think of this as sandwiching two segments together, where `eve.seg` is
                        // the bottom -- this will cause the above fill flag to toggle
                        if toggle {
                            let eve = eventRoot[eveIndex].value
                            
                            var es = segmentStore[eve.seg]
                            es.myFill.above = !es.myFill.above
                            es.myFill.isSet = true
                            
                            segmentStore[eve.seg] = es
                        }
                    } else {
                        // merge two segments that belong to different polygons
                        // each segment has distinct knowledge, so no special logic is needed
                        // note that this can only happen once per segment in this phase, because we
                        // are guaranteed that all self-intersections are gone

                        let eve = eventRoot[eveIndex].value
                        segmentStore[eve.seg].otherFill = s.myFill
                    }
                    
                    eventRoot.unlink(index: ev.other)
                    eventRoot.unlink(index: evItem.index)
                }
                
                guard eventRoot.first == evItem.index else {
                    // something was inserted before us in the event queue, so loop back around and
                    // process it before continuing
                    continue
                }
                
                //
                // calculate fill flags
                //
                if selfIntersection {
                    let toggle: Bool // are we a toggling edge?
                    if !s.myFill.isSet { // if we are a new segment...
                        toggle = true // then we toggle
                    } else { // we are a segment that has previous knowledge from a division
                        toggle = s.myFill.above != s.myFill.below // calculate toggle
                    }
                    
                    let myFillBelow: Bool
                    // next, calculate whether we are filled below us
                    if belowIndex >= 0 {
                        // otherwise, we know the answer -- it"s the same if whatever is below
                        // us is filled above it
                        
                        let below = eventRoot[belowIndex].value
                        let bs = segmentStore[below.seg]
                        myFillBelow = bs.myFill.above
                    } else {
                        // if nothing is below us...
                        // we are filled below us if the polygon is inverted
                        myFillBelow = primaryPolyInverted
                    }
                    s.myFill.below = myFillBelow
                    
                    // since now we know if we"re filled below us, we can calculate whether
                    // we"re filled above us by applying toggle to whatever is below us
                    if toggle {
                        s.myFill.above = !myFillBelow
                    } else {
                        s.myFill.above = s.myFill.below
                    }

                    s.myFill.isSet = true
                    
                    segmentStore[ev.seg] = s
                } else {
                    // now we fill in any missing transition information, since we are all-knowing
                    // at this point
                    
                    if !s.otherFill.isSet {
                        // if we don"t have other information, then we need to figure out if we"re
                        // inside the other polygon
                        let inside: Bool
                        if belowIndex >= 0 {
                            // otherwise, something is below us
                            // so copy the below segment"s other polygon"s above
                            
                            let below = eventRoot[belowIndex].value
                            let bs = segmentStore[below.seg]
                            if ev.primary == below.primary {
                                inside = bs.otherFill.above
                            } else {
                                inside = bs.myFill.above
                            }
                        } else {
                            // if nothing is below us, then we"re inside if the other polygon is
                            // inverted
                            inside = ev.primary ? secondaryPolyInverted : primaryPolyInverted
                        }
                        
                        s.otherFill = Fill(above: inside, below: inside, isSet: true)
                        segmentStore[ev.seg] = s
                    }
                }
                
                // insert the status and remember it for later removal
                let stIndex = statusRoot.insertBetween(a0: surrounding.before, a2: surrounding.after, value: evItem.index)

                eventRoot[ev.other].value.status = stIndex
            } else { // start
                guard statusRoot.exist(index: ev.status) else {
                    fatalError("PolyBool: Zero-length segment detected; your epsilon is probably too small or too large")
                }
                
                let stItem = statusRoot[ev.status]
                
                // removing the status will create two new adjacent edges, so we"ll need to check
                // for those
                if statusRoot.exist(index: stItem.prev) && statusRoot.exist(index: stItem.next) {
                    let prevEvIndex = statusRoot[stItem.prev].value
                    let nextEvIndex = statusRoot[stItem.next].value
                    
                    _ = checkIntersection(ev1: prevEvIndex, ev2: nextEvIndex)
                    
                    // update value
                    ev = eventRoot[evItem.index].value
                }
                
                // remove the status
                statusRoot.unlink(index: stItem.index) // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                
                // if we"ve reached this point, we"ve calculated everything there is to know, so
                // save the segment for reporting
                if !ev.primary {
                    // make sure `seg.myFill` actually points to the primary polygon though
                    
                    var s = segmentStore[ev.seg]
                    
                    let x = s.myFill
                    s.myFill = s.otherFill
                    s.myFill.isSet = true
                    s.otherFill = x
                    s.otherFill.isSet = true
                    
                    segmentStore[ev.seg] = s
                }
                
                segIndices.append(ev.seg)
            }
            
            // remove the event and continue
            eventRoot.unlink(index: evItem.index)
        }
        
        let segments = segIndices.map({ segmentStore[$0] })

        return segments
    }
    
}

private extension LinkedList where T == Node {
    
    mutating func insertBefore(item: Item<Node>, check: (Node, Node) -> Bool) {
        var index = first
        while index != -1 {
            let here = items[index]
            let other = items[here.value.other]
            
            if check(here.value, other.value) {
                return self.insertBefore(index: index, item: item)
            }
            index = here.next
        }

        return self.add(item: item)
    }

}

private extension LinkedList where T == Int {
    
    mutating func findTransition(eventList: LinkedList<Node>, segmentStore: SegmentStore, s1: Segment, geom: Geom) -> Transition {
        var index = first
        var prev = -1
        while index != -1 {
            let here = items[index]
            let evIndex = here.value
            
            let ev2 = eventList[evIndex].value
            let s2 = segmentStore[ev2.seg]
            
            let comp = Self.statusCompare(s1: s1, s2: s2, geom: geom)
            
            if comp > 0 {
                break
            }
            
            prev = index
            index = here.next
        }
        
        // before >> x >> after
        // prev >> x >> index
        return Transition(
            after: index,
            before: prev
        )
    }

    private static func statusCompare(s1: Segment, s2: Segment, geom: Geom) -> Int {
        let a1 = s1.start
        let a2 = s1.end
        let b1 = s2.start
        let b2 = s2.end
        
        if geom.arePointsCollinear(a1, b1, b2) {
            if geom.arePointsCollinear(a2, b1, b2) {
                return 1
            } else {
                return geom.pointAboveOrOnLine(a2, b1, b2) ? 1 : -1
            }
        }
        
        return geom.pointAboveOrOnLine(a1, b1, b2) ? 1 : -1
    }
    
}
