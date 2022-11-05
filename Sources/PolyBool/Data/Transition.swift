//
//  Transition.swift
//  
//
//  Created by Nail Sharipov on 04.11.2022.
//

struct Transition {

    static let empty = Transition(after: -1, before: -1)

    let after: Int
    let before: Int

}
