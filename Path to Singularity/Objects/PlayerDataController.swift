//
//  PlayerData.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/28/22.
//

import UIKit
import CoreData


class PlayerDataController: ObservableObject {
    
    var playerData: [NSManagedObject] = []
    
    func getPlayerData(_ obj: String) -> Any {
        return playerData[0].value(forKey: obj)!
    }
    
    func loadPlayerData() {
        do {
            playerData = try CoreData.shared.managedContext.fetch(Player.fetchRequest())
            myPlayer = playerData[0] as? Player
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveData() {
        if playerData.isEmpty {
            let data = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Player", in: CoreData.shared.managedContext)!, insertInto: CoreData.shared.managedContext)
            playerData.append(data)
        }
        playerData[0].setValue(myPlayer.energy, forKey: "energy")
        playerData[0].setValue(myPlayer.boostValue, forKey: "boostValue")
        
        do {
            try CoreData.shared.managedContext.save()
            def.set(true, forKey: "has_saved_data")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
