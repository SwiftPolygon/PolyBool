//
//  Geom.swift
//  
//
//  Created by Nail Sharipov on 04.11.2022.
//

import Geom

extension Geom {

    @inlinable
    func pointsCompare(_ a: Point, _ b: Point) -> Int {
        if abs(a.x - b.x) < eps {
            return abs(a.y - b.y) < eps ? 0 : (a.y < b.y ? -1 : 1)
        }
        return a.x < b.x ? -1 : 1
    }

    @inlinable
    func pointAboveOrOnLine(_ point: Point, _ left: Point, _ right: Point) -> Bool {
        (right.x - left.x) * (point.y - left.y) - (right.y - left.y) * (point.x - left.x) >= -eps
    }
    
    @inlinable
    func pointBetween(_ point: Point, _ left: Point, right: Point) -> Bool {
        // p must be collinear with left->right
        // returns false if p == left, p == right, or left == right
        let dPyLy = point.y - left.y
        let dRxLx = right.x - left.x
        let dPxLx = point.x - left.x
        let dRyLy = right.y - left.y

        let dot = dPxLx * dRxLx + dPyLy * dRyLy

        guard dot < eps else {
            return false
        }

        let sqlen = dRxLx * dRxLx + dRyLy * dRyLy

        return dot - sqlen <= -eps
    }
}
