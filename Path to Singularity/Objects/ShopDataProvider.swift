//
//  ShopDataProvider.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 5/26/23.
//

import UIKit

class ShopDataProvider {
    var availableStars: [StarItem] = [
        
    ]
    
    var availableBoosts: [BoostItem] = [
        BoostItem(name: "Chlorophyll", price: 10, image: UIImage(named: "chlorophyll")!,
                 bonusEnergy: 1),
        BoostItem(name: "Algae", price: 40, image: UIImage(named: "algae")!,
                 bonusEnergy: 2),
        BoostItem(name: "Tree", price: 200, image: UIImage(named: "tree")!,
                 bonusEnergy: 4),
        BoostItem(name: "Solar Panel", price: 1000, image: UIImage(named: "solarpanel")!,
                 bonusEnergy: 10),
        BoostItem(name: "Field of Panels", price: 50_000, image: UIImage(named: "fieldofpanels")!,
                 bonusEnergy: 200),
        BoostItem(name: "Forest", price: 250_000, image: UIImage(named: "forest")!,
                 bonusEnergy: 4000)
    ]
}
