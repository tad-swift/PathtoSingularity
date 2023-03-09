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
    
    init(playerDataController: PlayerDataController, starDataController: StarDataController) {
        self.playerDataController = playerDataController
        self.starDataController = starDataController
    }
    
    func createNewData() {
        myPlayer = Player(boostValue: 1, energy: 0)
        starDataController.myStar = Star(name: "Proxima Centauri", zams: 0.8, energy: 100_000, maxEnergy: 100_000, rotationSpeed: 1, fuseRate: 1, isAlive: true, color: [1,0,0], node: SCNNode())
    }
    
}
