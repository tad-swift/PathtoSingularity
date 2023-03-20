//
//  Player.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/29/22.
//
//

import Foundation

class Player: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var boostValue: Double
    var energy: Double
    
    init(boostValue: Double = 1, energy: Double = 0) {
        self.boostValue = boostValue
        self.energy = energy
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.boostValue = aDecoder.decodeDouble(forKey: "boostValue")
        self.energy = aDecoder.decodeDouble(forKey: "energy")
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(boostValue, forKey: "boostValue")
        aCoder.encode(energy, forKey: "energy")
    }
}

