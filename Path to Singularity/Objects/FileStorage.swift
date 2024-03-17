//
//  FileStorage.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 3/19/23.
//

import Foundation

enum FileStorage {
    
    static let starDir = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("StarData")
    
    static let playerDir = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("PlayerData")
    
    static func save(_ star: Star) {
        let starData = try? NSKeyedArchiver.archivedData(
            withRootObject: star,
            requiringSecureCoding: true
        )
        try? starData?.write(to: starDir)
    }
    
    static func save(_ player: Player) {
        let playerData = try? NSKeyedArchiver.archivedData(
            withRootObject: player,
            requiringSecureCoding: true
        )
        try? playerData?.write(to: playerDir)
    }
    
    static func getStar() -> Star? {
        guard FileManager.default.fileExists(atPath: starDir.path()) else { return nil }
        if let starData = FileManager.default.contents(atPath: starDir.path()) {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: Star.self, from: starData)
        }
        return nil
    }
    
    static func getPlayer() -> Player? {
        guard FileManager.default.fileExists(atPath: playerDir.path()) else { return nil }
        if let playerData = FileManager.default.contents(atPath: playerDir.path()) {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: Player.self, from: playerData)
        }
        return nil
    }
    
}
