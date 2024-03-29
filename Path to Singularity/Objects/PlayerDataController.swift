//
//  PlayerData.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/28/22.
//

import UIKit

class PlayerDataController {
    
    var myPlayer: Player!
    
    init() {
        loadPlayerData()
    }
    
    func loadPlayerData() {
        if let player = FileStorage.getPlayer() {
            myPlayer = player
        } else {
            myPlayer = Player()
        }
    }
    
    func saveData() {
        FileStorage.save(myPlayer)
    }
}
