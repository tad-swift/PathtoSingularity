//
//  Star.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 3/30/21.
//

import Foundation
import UIKit
import SceneKit


class Star: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        true
    }
    
    var energy: Double
    var fuseRate: Double
    var isAlive: Bool
    var maxEnergy: Double
    var name: String?
    var rotationSpeed: Double
    var scalex: Float
    var scaley: Float
    var scalez: Float
    var zams: Double
    var color: UIColor
    var node: SCNNode
    
    internal init(energy: Double, fuseRate: Double, isAlive: Bool = true, maxEnergy: Double, name: String? = nil, rotationSpeed: Double = 1, scalex: Float = 1, scaley: Float = 1, scalez: Float = 1, zams: Double = 0.8, color: UIColor = .red, node: SCNNode = SCNNode()) {
        self.energy = energy
        self.fuseRate = fuseRate
        self.isAlive = isAlive
        self.maxEnergy = maxEnergy
        self.name = name
        self.rotationSpeed = rotationSpeed
        self.scalex = scalex
        self.scaley = scaley
        self.scalez = scalez
        self.zams = zams
        self.color = color
        self.node = node
    }
    
    required init?(coder: NSCoder) {
        guard let node = coder.decodeObject(of: SCNNode.self, forKey: "node") else {
            return nil
        }
        
        self.node = node
        self.energy = coder.decodeDouble(forKey: "energy")
        self.fuseRate = coder.decodeDouble(forKey: "fuseRate")
        self.isAlive = coder.decodeBool(forKey: "isAlive")
        self.maxEnergy = coder.decodeDouble(forKey: "maxEnergy")
        self.name = coder.decodeObject(of: NSString.self, forKey: "name") as String?
        self.rotationSpeed = coder.decodeDouble(forKey: "rotationSpeed")
        self.scalex = coder.decodeFloat(forKey: "scalex")
        self.scaley = coder.decodeFloat(forKey: "scaley")
        self.scalez = coder.decodeFloat(forKey: "scalez")
        self.zams = coder.decodeDouble(forKey: "zams")
        self.color = coder.decodeObject(of: UIColor.self, forKey: "color") ?? .red
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(node, forKey: "node")
        aCoder.encode(energy, forKey: "energy")
        aCoder.encode(fuseRate, forKey: "fuseRate")
        aCoder.encode(isAlive, forKey: "isAlive")
        aCoder.encode(maxEnergy, forKey: "maxEnergy")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(rotationSpeed, forKey: "rotationSpeed")
        aCoder.encode(scalex, forKey: "scalex")
        aCoder.encode(scaley, forKey: "scaley")
        aCoder.encode(scalez, forKey: "scalez")
        aCoder.encode(zams, forKey: "zams")
        aCoder.encode(color, forKey: "color")
    }
    
}

extension Star {
    
    func creatNode(radius: CGFloat = 0.3, surfaceImageString: String = "gray1") {
        node = SCNNode(geometry: SCNSphere(radius: radius))
        let surface = SCNMaterial()
        var surfaceImage = UIImage(named: surfaceImageString)!
        
        if let colorFilter = CIFilter(name: "CIMultiplyCompositing"),
           let inputColor = CIFilter(name: "CIConstantColorGenerator") {
            let ciSurfaceImage = CIImage(image: surfaceImage)
            inputColor.setValue(CIColor(color: color), forKey: kCIInputColorKey)
            colorFilter.setValue(inputColor.outputImage, forKey: kCIInputImageKey)
            colorFilter.setValue(ciSurfaceImage, forKey: kCIInputBackgroundImageKey)
            
            if let outputImage = colorFilter.outputImage {
                let context = CIContext(options: nil)
                if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    surfaceImage = UIImage(cgImage: cgImage)
                }
            }
        }
        
        surface.diffuse.contents = surfaceImage
        surface.emission.contents = color
        surface.emission.intensity = 0.1
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.color = color
        lightNode.light?.intensity = 2700
        node.addChildNode(lightNode)
        
        node.geometry?.insertMaterial(surface, at: 0)
        node.scale = SCNVector3(1, 1, 1)
        node.addParticleSystem(createCorona())
        node.addParticleSystem(createStarParticle())
    }
    
    func createCorona() -> SCNParticleSystem {
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
        return corona
    }
    
    func createStarParticle() -> SCNParticleSystem {
        let starParticle = SCNParticleSystem()
        starParticle.birthRate = 400
        starParticle.birthDirection = .random
        starParticle.emitterShape = node.geometry
        starParticle.particleLifeSpan = 11
        starParticle.particleVelocity = 0.4
        starParticle.stretchFactor = 0.1
        starParticle.particleColor = color
        starParticle.particleSize = 0.001
        starParticle.blendMode = .additive
        return starParticle
    }
    
    func die() {
        switch zams {
        case 0..<0.5:
            becomeWhiteDwarf()
        case 0.5..<8:
            becomeRedGiant {
                self.becomeWhiteDwarf()
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
            if self.zams > 20 {
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
        self.node.removeAllParticleSystems()
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
        self.node.removeAllParticleSystems()
        self.node.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        self.node.light?.intensity = 0
        let bhScene = SCNScene(named: "art.scnassets/BlackHole.scn")!
        let bh = bhScene.rootNode.childNode(withName: "BlackHole", recursively: true)!
        bh.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 3, z: 0, duration: 0.3)))
        self.node.addChildNode(bh)
    }
    
    func createBlackHoleParticles() -> SCNParticleSystem {
        let particleSystem = SCNParticleSystem()
        
        // Configure the particle system
        particleSystem.birthRate = 300
        particleSystem.particleLifeSpan = 5.0
        particleSystem.particleLifeSpanVariation = 1.0
        particleSystem.emissionDuration = .greatestFiniteMagnitude
        particleSystem.loops = true
        particleSystem.particleSize = 0.02
        particleSystem.particleVelocity = 50
        particleSystem.particleVelocityVariation = 10
        particleSystem.spreadingAngle = 180
        particleSystem.emittingDirection = SCNVector3(0, 0, -1)
        
        // Set the particle appearance
        particleSystem.particleColor = .white
        particleSystem.blendMode = .additive
//        particleSystem.opacityVariation = 0.2
        particleSystem.particleIntensity = 1.0
        particleSystem.particleIntensityVariation = 0.5
        
        // Use a radial force field to attract particles towards the center
        let forceField = SCNPhysicsField.radialGravity()
        forceField.strength = -3.0
//        particleSystem.addPhysicsField(forceField)
        
        return particleSystem
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
