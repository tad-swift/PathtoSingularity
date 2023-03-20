//
//  StarDataController.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/28/22.
//

import UIKit
import SceneKit

class StarDataController: ObservableObject {
    
    var myStar: Star!
    
    func loadStarData() {
        if let star = FileStorage.shared.getStar() {
            myStar = star
        } else {
            myStar = Star(energy: 100_000, fuseRate: 1, maxEnergy: 100_000)
        }
        myStar.creatNode()
    }
    
    func saveData() {
        FileStorage.shared.save(star: myStar)
    }
    
}
