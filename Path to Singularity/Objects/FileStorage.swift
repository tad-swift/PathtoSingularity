//
//  FileStorage.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 3/19/23.
//

import Foundation

final class FileStorage {
    
    static let shared = FileStorage()
    
    let starDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("StarData")
    let playerDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("PlayerData")
    
    func save(star: Star) {
        let starData = try? NSKeyedArchiver.archivedData(withRootObject: star, requiringSecureCoding: true)
        try? starData?.write(to: starDir)
    }
    
    func save(player: Player) {
        let playerData = try? NSKeyedArchiver.archivedData(withRootObject: player, requiringSecureCoding: true)
        try? playerData?.write(to: playerDir)
    }
    
    func getStar() -> Star? {
        if let starData = FileManager.default.contents(atPath: starDir.path()) {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: Star.self, from: starData)
        }
        return nil
    }
    
    func getPlayer() -> Player? {
        if let playerData = FileManager.default.contents(atPath: playerDir.path()) {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: Player.self, from: playerData)
        }
        return nil
    }
    
}
