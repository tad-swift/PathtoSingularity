//
//  ShopItem.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 4/2/21.
//

import UIKit

struct ShopItem: Hashable {
    
    let name: String
    let itemType: ItemType
    var price: Double
    let image: UIImage
    let item: Any
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(price)
    }
    
    static func == (lhs: ShopItem, rhs: ShopItem) -> Bool {
        lhs.price == rhs.price && lhs.name == rhs.name
    }
}

struct BoostItem {
    let name: String
    let value: Double
}

enum ItemType: CaseIterable {
    case star
    case boostItem
}
