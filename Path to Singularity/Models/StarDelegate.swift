//
//  StarDelegate.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 3/17/24.
//

import Foundation

enum StarPhase {
    case redGiant, whiteDwarf, neutron, blackHole
}

protocol StarDelegate: AnyObject {
    
    func didChangePhase(_ phase: StarPhase)
    
}
