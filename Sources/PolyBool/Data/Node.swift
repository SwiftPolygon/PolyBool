//
//  Node.swift
//  
//
//  Created by Nail Sharipov on 03.11.2022.
//

import Geom

struct Node {
    
    static let empty = Node(
        status: -1,
        other: -1,
        ev: -1,
        isStart: false,
        pt: .zero,
        seg: Segment(start: .zero, end: .zero, myFill: .init(above: false, below: false)),
        primary: false
    )
    
    var status: Int // index in statusRoot
    var other: Int
    var ev: Int
    var isStart: Bool
    var pt: Point
    var seg: Segment
    var primary: Bool
}