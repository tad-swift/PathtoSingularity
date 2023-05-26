//
//  ShopView.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 5/26/23.
//

import SwiftUI

struct ShopView: View {
    
    enum Section {
        case boosts, stars
    }
    
    @StateObject var dataProvider = ShopDataProvider()
    
    @State private var section: Section = .boosts
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Text("Boosts")
                }
                Button {
                    
                } label: {
                    Text("Stars")
                }
            }
            switch section {
            case .boosts:
                List(dataProvider.availableBoosts) { boost in
                    VStack {
                        Text(boost.name)
                        Text("+\(boost.bonusEnergy.abbreviated) ✨ boost")
                    }
                }
            case .stars:
                List(dataProvider.availableStars) { star in
                    VStack {
                        Text(star.name)
                    }
                }
                
            }
        }
        
    }
}
