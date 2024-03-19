//
//  MainSceneViewModel.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/28/22.
//

import UIKit

@dynamicMemberLookup
class MainSceneViewModel {
    
    let eventsController = EventsController()
    let playerDataController: PlayerDataController
    let starDataController: StarDataController
    
    init(
        playerDataController: PlayerDataController,
        starDataController: StarDataController
    ) {
        self.playerDataController = playerDataController
        self.starDataController = starDataController
    }
    
    func saveData() {
        playerDataController.saveData()
        starDataController.saveData()
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<PlayerDataController, T>) -> T {
        return playerDataController[keyPath: keyPath]
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<StarDataController, T>) -> T {
        return starDataController[keyPath: keyPath]
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<EventsController, T>) -> T {
        return eventsController[keyPath: keyPath]
    }
}
