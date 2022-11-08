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
        isStart: false,
        pt: .zero,
        seg: -1,
        primary: false
    )
    
    var status: Int // index in statusRoot
    var other: Int
    let isStart: Bool
    var pt: Point
    let seg: Int
    let primary: Bool
}
