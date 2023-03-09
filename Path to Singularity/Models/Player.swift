//
//  Player+CoreDataClass.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/29/22.
//
//

import Foundation
import CoreData

@objc(Player)
public class Player: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }
    
    @NSManaged public var boostValue: Double
    @NSManaged public var energy: Double
    
    init(boostValue: Double, energy: Double) {
        super.init(entity: NSEntityDescription(), insertInto: CoreData.shared.managedContext)
        self.boostValue = boostValue
        self.energy = energy
    }
    
}
