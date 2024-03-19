//
//  Scale.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 3/17/24.
//

import Foundation

class Scale: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool { true }
    
    let x: Float
    let y: Float
    let z: Float
    
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    required init?(coder: NSCoder) {
        self.x = coder.decodeFloat(forKey: "x")
        self.y = coder.decodeFloat(forKey: "y")
        self.z = coder.decodeFloat(forKey: "z")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(x, forKey: "x")
        coder.encode(y, forKey: "y")
        coder.encode(z, forKey: "z")
    }
    
}
