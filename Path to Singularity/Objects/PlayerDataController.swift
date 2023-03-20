//
//  PlayerData.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/28/22.
//

import UIKit

class PlayerDataController: ObservableObject {
    
    var myPlayer: Player!
    
    func loadPlayerData() {
        if let player = FileStorage.shared.getPlayer() {
            myPlayer = player
        } else {
            myPlayer = Player()
        }
    }
    
    func saveData() {
        FileStorage.shared.save(player: myPlayer)
    }
}
