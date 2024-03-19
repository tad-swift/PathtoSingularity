//
//  Player.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/29/22.
//
//

import Foundation

class Player: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool { return true }
    
    var boostValue: Double
    
    var energy: Double
    
    init(boostValue: Double = 10000, energy: Double = 0) {
        self.boostValue = boostValue
        self.energy = energy
    }
    
    required init?(coder: NSCoder) {
        self.boostValue = coder.decodeDouble(forKey: "boostValue")
        self.energy = coder.decodeDouble(forKey: "energy")
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(boostValue, forKey: "boostValue")
        coder.encode(energy, forKey: "energy")
    }
}

