//
//  MainSceneViewModel.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/28/22.
//

import UIKit
import SceneKit

class MainSceneViewModel: ObservableObject {
    
    let eventsController = EventsController()
    var playerDataController: PlayerDataController
    var starDataController: StarDataController
    
    var myPlayer: Player {
        playerDataController.myPlayer
    }
    
    var myStar: Star {
        starDataController.myStar
    }
    
    init(playerDataController: PlayerDataController, starDataController: StarDataController) {
        self.playerDataController = playerDataController
        self.starDataController = starDataController
        playerDataController.loadPlayerData()
        starDataController.loadStarData()
    }
    
}
