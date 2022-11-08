//
//  Geom.swift
//  
//
//  Created by Nail Sharipov on 08.11.2022.
//

import Geom

extension Geom {
    
    @inlinable
    func isSame(_ a1: [Point], _ a2: [Point], anyDirection: Bool = true) -> Bool {
        guard a1.count == a2.count else { return false }

        let isDirect = self.compare(a1, a2)

        guard anyDirection && !isDirect else {
            return isDirect
        }
        
        let a3 = Array(a2.reversed())

        return self.compare(a1, a3)
    }

    @inlinable
    func compare(_ a1: [Point], _ a2: [Point]) -> Bool {
        let n = a1.count
        
        for i in 0..<n {
            
            var isSame = true
            
            for j in 0..<n {
                let k = (i + j) % n
                
                if !self.isSamePoints(a1[k], a2[j]) {
                    isSame = false
                    break
                }
            }
            
            if isSame {
                return true
            }
        }
        
        return false
    }
    
    
    
}
