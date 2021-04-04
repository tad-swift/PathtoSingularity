//
//  Star.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 3/30/21.
//

import Foundation
import UIKit
import SceneKit

struct Star {
    
    var name: String
    var zams: Double // zero age main sequence mass
    var energy: Double
    var maxEnergy: Double
    var rotationSpeed: Double
    var fuseRate: Double
    var isAlive: Bool
    var color: UIColor
    var node: SCNNode // used to reference/modify the node
    
    // used to create a new node
    mutating func creatNode(radius: CGFloat = 0.3, surfaceImageString: String = "gray1") {
        node = SCNNode(geometry: SCNSphere(radius: radius))
        node.light?.intensity = 2_700
        node.light?.type = .ambient
        let surface = SCNMaterial()
        let surfaceImage = UIImage(named: surfaceImageString)!
        surface.diffuse.contents = surfaceImage
        surface.emission.contents = color
        node.geometry?.insertMaterial(surface, at: 0)
        
        let corona = SCNParticleSystem()
        corona.birthRate = 10_000
        corona.birthDirection = .random
        corona.emitterShape = node.geometry
        corona.particleLifeSpan = 1.5
        corona.particleVelocity = 0.03
        corona.speedFactor = 2.9
        corona.stretchFactor = 0.087
        corona.particleColor = color
        corona.particleSize = 0.001
        corona.blendMode = .additive
        let starParticle = SCNParticleSystem()
        starParticle.birthRate = 25
        starParticle.birthDirection = .random
        starParticle.emitterShape = node.geometry
        starParticle.particleLifeSpan = 11
        starParticle.particleVelocity = 0.1
        starParticle.stretchFactor = 0.1
        starParticle.particleColor = color
        starParticle.particleSize = 0.001
        starParticle.blendMode = .additive
        
        node.scale = SCNVector3(1, 1, 1)
        node.addParticleSystem(corona)
        node.addParticleSystem(starParticle)
    }
    
    func die() {
        switch zams {
            case 0..<0.5:
                becomeWhiteDwarf()
            case 0.5..<8:
                becomeRedGiant {
                    becomeWhiteDwarf()
                }
            case 8...100_000_000_000:
                performSuperNova()
            default:
                becomeWhiteDwarf()
                
        }
    }
    
    func performSuperNova() {
        let starParticle = SCNParticleSystem()
        starParticle.birthRate = 10_000
        starParticle.birthDirection = .random
        starParticle.emitterShape = self.node.geometry
        starParticle.particleLifeSpan = 4
        starParticle.particleVelocity = 5
        starParticle.stretchFactor = 0.8
        starParticle.particleColor = UIColor.init(red: 0.8, green: 0.8, blue: 1, alpha: 1)
        starParticle.particleSize = 0.001
        starParticle.blendMode = .additive
        let starParticle2 = SCNParticleSystem()
        starParticle2.birthRate = 10_000
        starParticle2.birthDirection = .random
        starParticle2.emitterShape = self.node.geometry
        starParticle2.particleLifeSpan = 4
        starParticle2.particleVelocity = 5
        starParticle2.stretchFactor = 0.8
        starParticle2.particleColor = UIColor.init(red: 1, green: 0.8, blue: 0.8, alpha: 1)
        starParticle2.particleSize = 0.001
        starParticle2.blendMode = .additive
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.node.removeAllParticleSystems()
            if self.zams > 25 {
                self.createBlackHole()
            } else {
                self.becomeNeutron()
            }
        }
        self.node.runAction(SCNAction.scale(to: 0.005, duration: 5)) {
            self.node.removeAllParticleSystems()
            self.node.addParticleSystem(starParticle)
            self.node.addParticleSystem(starParticle2)
        }
    }
    
    func becomeWhiteDwarf() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 5
        
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 10
            for system in self.node.particleSystems! {
                system.particleColor = UIColor.white
                system.birthRate /= 4
            }
            SCNTransaction.completionBlock = {
                for system in self.node.particleSystems! {
                    system.birthRate /= 4
                }
            }
            
            self.node.geometry?.firstMaterial?.emission.contents = UIColor.darkGray
            SCNTransaction.commit()
        }
        for system in node.particleSystems! {
            system.particleColor = UIColor.blue
        }
        node.scale = SCNVector3(0.4, 0.4, 0.4)
        node.geometry?.firstMaterial?.emission.contents = UIColor.blue
        SCNTransaction.commit()
    }
    
    func becomeRedGiant(completion: @escaping () -> Void) {
        let oldScale = node.scale
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 30
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 10
            SCNTransaction.completionBlock = {
                completion()
            }
            self.node.scale = oldScale
            SCNTransaction.commit()
        }
        for system in node.particleSystems! {
            system.particleColor = UIColor.red
        }
        node.scale = SCNVector3(2.5, 2.5, 2.5)
        SCNTransaction.commit()
    }
    
    func becomeNeutron() {
        node.removeAllActions()
        node.scale = SCNVector3(0.3, 0.3, 0.3)
        self.node.addChildNode(neutronJet(SCNVector3(0, 0.25, 0)))
        self.node.addChildNode(neutronJet(SCNVector3(0, -0.25, 0)))
        self.node.physicsField = neutronStarPhysicsField()
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 5
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 10
            self.node.geometry?.firstMaterial?.emission.contents = UIColor.cyan
            SCNTransaction.commit()
        }
        node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 3, y: 0, z: 0, duration: 0.3)))
        node.geometry?.firstMaterial?.emission.contents = UIColor.darkGray
        SCNTransaction.commit()
    }
    
    func createBlackHole() {
        self.node.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        self.node.light?.intensity = 0
        let bhScene = SCNScene(named: "art.scnassets/BlackHole.scn")!
        let bh = bhScene.rootNode.childNode(withName: "BlackHole", recursively: true)!
        //bh.scale = SCNVector3(1, 1, 1)
        self.node.addChildNode(bh)
        //self.node.runAction(SCNAction.scale(by: 40, duration: 2))
    }
    
    func neutronJet(_ position: SCNVector3 = SCNVector3(0, 0, 0)) -> SCNNode {
        let node = SCNNode()
        let jet = SCNParticleSystem()
        jet.birthRate = 5_000
        jet.emitterShape = SCNCylinder(radius: 0.024, height: 0.006)
        jet.birthDirection = .constant
        jet.emittingDirection = SCNVector3(0, 0, 0)
        jet.particleLifeSpan = 0.05
        jet.particleVelocity = 0
        jet.speedFactor = 0.7
        jet.acceleration = SCNVector3(0, 0, 0)
        jet.stretchFactor = 0.1
        jet.particleColor = UIColor.cyan
        jet.particleColorVariation = SCNVector4(0.2, 0, 0, 0)
        jet.particleSize = 0.001
        jet.particleIntensity = 1
        jet.isAffectedByPhysicsFields = true
        node.position = position
        node.addParticleSystem(jet)
        return node
    }
    
    
    func neutronStarPhysicsField() -> SCNPhysicsField {
        let field = SCNPhysicsField.radialGravity()
        field.halfExtent = SCNVector3(0.07, 2, 0.07)
        field.scope = .insideExtent
        field.usesEllipsoidalExtent = true
        field.isExclusive = true
        return field
    }
    
}