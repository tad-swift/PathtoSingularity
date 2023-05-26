//
//  ShopItem.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 4/2/21.
//

import UIKit

protocol ShopItem {
    var name: String { get }
    var price: Double { get }
    var image: UIImage { get }
    var id: String { get }
}

struct BoostItem: ShopItem, Identifiable {
    let name: String
    let price: Double
    let image: UIImage
    let bonusEnergy: Double
    var id: String {
        name
    }
}

struct StarItem: ShopItem, Identifiable {
    let name: String
    let price: Double
    let image: UIImage
    var star: Star
    var id: String {
        name
    }
}
