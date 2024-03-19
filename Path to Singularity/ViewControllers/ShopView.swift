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
    
    private var dataProvider = ShopDataProvider()
    
    @State private var section: Section = .boosts
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    section = .boosts
                } label: {
                    Text("Boosts")
                }
                Button {
                    section = .stars
                } label: {
                    Text("Stars")
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            switch section {
            case .boosts:
                BoostList(boosts: dataProvider.availableBoosts)
            case .stars:
                StarList(stars: dataProvider.availableStars)
            }
        }
    }
}

extension ShopView {
    
    struct BoostList: View {
        
        let boosts: [BoostItem]
        
        var body: some View {
            List(boosts) { boost in
                VStack {
                    Text(boost.name)
                    Text("+\(boost.bonusEnergy.abbreviated) ✨ boost")
                }
            }
            .listStyle(.plain)
        }
    }
    
    struct StarList: View {
        
        let stars: [StarItem]
        
        var body: some View {
            List(stars) { star in
                VStack {
                    Text(star.name)
                }
            }
            .listStyle(.plain)
        }
    }
}
