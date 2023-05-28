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
    
    @StateObject private var dataProvider = ShopDataProvider()
    
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
                BoostList(boosts: dataProvider.availableBoosts)
            case .stars:
                StarList(stars: dataProvider.availableStars)
            }
        }
    }
}

fileprivate struct BoostList: View {
    
    var boosts: [BoostItem]
    
    var body: some View {
        List(boosts) { boost in
            VStack {
                Text(boost.name)
                Text("+\(boost.bonusEnergy.abbreviated) ✨ boost")
            }
        }
    }
}

fileprivate struct StarList: View {
    
    var stars: [StarItem]
    
    var body: some View {
        List(stars) { star in
            VStack {
                Text(star.name)
            }
        }
    }
}
