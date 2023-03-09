//
//  StarDataController.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/28/22.
//

import UIKit
import CoreData
import SceneKit


class StarDataController: ObservableObject {
    
    var myStar: Star!
    
    var starData: [NSManagedObject] = []
    
    func getStarData(_ obj: String) -> Any {
        return starData[0].value(forKey: obj)!
    }
    
    func loadStarData() {
        do {
            starData = try CoreData.shared.managedContext.fetch(Star.fetchRequest())
            
            let colors: [Float] = [getStarData("colorr") as! Float,
                                   getStarData("colorg") as! Float,
                                   getStarData("colorb") as! Float]
            
            myStar = Star(name: getStarData("name") as! String,
                          zams: getStarData("zams") as! Double,
                          energy: getStarData("energy") as! Double,
                          maxEnergy: getStarData("maxEnergy") as! Double,
                          rotationSpeed: getStarData("rotationSpeed") as! Double,
                          fuseRate: getStarData("fuseRate") as! Double,
                          isAlive: getStarData("isAlive") as! Bool,
                          color: colors,
                          node: SCNNode())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @objc func saveData() {
        if starData.isEmpty {
            let data = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Star", in: CoreData.shared.managedContext)!, insertInto: CoreData.shared.managedContext)
            starData.append(data)
        }
        
        starData[0].setValue(Float(myStar.color.components.red), forKey: "colorr")
        starData[0].setValue(Float(myStar.color.components.green), forKey: "colorg")
        starData[0].setValue(Float(myStar.color.components.blue), forKey: "colorb")
        starData[0].setValue(myStar.zams, forKey: "zams")
        starData[0].setValue(myStar.rotationSpeed, forKey: "rotationSpeed")
        starData[0].setValue(myStar.isAlive, forKey: "isAlive")
        starData[0].setValue(myStar.name, forKey: "name")
        starData[0].setValue(myStar.fuseRate, forKey: "fuseRate")
        starData[0].setValue(myStar.energy, forKey: "energy")
        starData[0].setValue(myStar.maxEnergy, forKey: "maxEnergy")
        starData[0].setValue(myStar.node.scale.x, forKey: "scalex")
        starData[0].setValue(myStar.node.scale.y, forKey: "scaley")
        starData[0].setValue(myStar.node.scale.z, forKey: "scalez")
        
        do {
            try CoreData.shared.managedContext.save()
            def.set(true, forKey: "has_saved_data")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
