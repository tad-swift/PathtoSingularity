//
//  MainViewController.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 3/30/21.
//

import UIKit
import SceneKit
import CoreData

final class MainViewController: UIViewController {
    
    let sceneView = SCNView()
    
    let energyLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let energyBar: UIProgressView = {
        let v = UIProgressView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var lifeTimer: Timer!
    var autoTimer: Timer!
    var saveTimer: Timer!
    var playerData: [NSManagedObject] = []
    var starData: [NSManagedObject] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if def.bool(forKey: "has_saved_data") == true {
            loadPlayerData()
            loadStar()
            createViews()
            setScene()
        } else {
            createNewData()
            myStar.creatNode()
            createViews()
            setScene()
        }
        createLifeTimer()
        createAutoTimer()
        createSaveTimer()
    }
    
    func activateConstraints() {
        sceneView.frame = view.bounds
        view.addSubviews(sceneView, energyBar, energyLabel)
        NSLayoutConstraint.activate([
            energyBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            energyBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            energyBar.widthAnchor.constraint(equalToConstant: 200),
            
            energyLabel.leadingAnchor.constraint(equalTo: energyBar.leadingAnchor),
            energyLabel.topAnchor.constraint(equalTo: energyBar.bottomAnchor)
        ])
    }
    
    func createNewData() {
        myPlayer = Player(energy: 0, boostValue: 1)
        myStar = Star(name: "Proxima Centauri", zams: 0.8, energy: 100_000, maxEnergy: 100_000, rotationSpeed: 1, fuseRate: 1, isAlive: true, color: UIColor.red, node: SCNNode())
    }
    
    func loadPlayerData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let playerRequest = NSFetchRequest<NSManagedObject>(entityName: "PlayerData")
        let starRequest = NSFetchRequest<NSManagedObject>(entityName: "StarData")
        do {
            playerData = try managedContext.fetch(playerRequest)
            starData = try managedContext.fetch(starRequest)
            myPlayer = Player(energy: getPlayerData("energy") as! Double,
                              boostValue: getPlayerData("boostValue") as! Double)
            let colors: [Float] = [getStarData("colorr") as! Float,
                                   getStarData("colorg") as! Float,
                                   getStarData("colorb") as! Float]
            
            myStar = Star(name: getStarData("name") as! String,
                          zams: getStarData("zams") as! Double,
                          energy: getStarData("energy") as! Double,
                          maxEnergy: getStarData("maxEnergy") as! Double,
                          rotationSpeed: getStarData("rotationSpeed") as! Double,
                          fuseRate: getStarData("fuseRate") as! Double,
                          isAlive: getStarData("isAlive") as! Bool,
                          color: UIColor(red: CGFloat(colors[0]), green: CGFloat(colors[1]), blue: CGFloat(colors[2]), alpha: 1),
                          node: SCNNode())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func getStarData(_ obj: String) -> Any {
        return starData[0].value(forKey: obj)!
    }
    
    func getPlayerData(_ obj: String) -> Any {
        return playerData[0].value(forKey: obj)!
    }
    
    func setScene() {
        sceneView.scene?.physicsWorld.gravity = SCNVector3Zero
        sceneView.allowsCameraControl = true
        sceneView.scene?.rootNode.childNode(withName: "camera", recursively: true)?.position = SCNVector3(0, 1.4, 4)
        sceneView.scene = SCNScene(named: "art.scnassets/MainScene.scn")
        sceneView.scene?.rootNode.addChildNode(myStar.node)
        myStar.node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(myStar.rotationSpeed), z: 0, duration: 1)))
    }
    
    func createLifeTimer() {
        lifeTimer = Timer(timeInterval: 0.1, target: self, selector: #selector(fireLifeTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(lifeTimer, forMode: .common)
    }
    
    func createAutoTimer() {
        autoTimer = Timer(timeInterval: 1, target: self, selector: #selector(fireAutoTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(autoTimer, forMode: .common)
    }
    
    func createSaveTimer() {
        saveTimer = Timer(timeInterval: 5, target: self, selector: #selector(saveData), userInfo: nil, repeats: true)
        RunLoop.current.add(saveTimer, forMode: .common)
    }
    
    func createViews() {
        energyLabel.font = .roundedFont(ofSize: 22, weight: .bold)
        energyBar.progress = Float(myStar.energy / myStar.maxEnergy)
        updateLabels()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: NSNotification.Name(rawValue: "updateLabels"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStar), name: NSNotification.Name(rawValue: "reloadStar"), object: nil)
    }
    
    func loadStar() {
        myStar.node = SCNNode(geometry: SCNSphere(radius: 0.3))
        myStar.node.scale = SCNVector3(getStarData("scalex") as! Float, getStarData("scaley") as! Float, getStarData("scalez") as! Float)
        myStar.node.light?.intensity = 2_300
        myStar.node.light?.type = .ambient
        let surface = SCNMaterial()
        let surfaceImage = UIImage(named: "gray1")?.withTintColor(myStar.color)
        surface.diffuse.contents = surfaceImage
        myStar.node.geometry?.insertMaterial(surface, at: 0)
        
        let corona = SCNParticleSystem()
        corona.birthRate = 10_000
        corona.birthDirection = .random
        corona.emitterShape = myStar.node.geometry
        corona.particleLifeSpan = 1.5
        corona.particleVelocity = 0.03
        corona.speedFactor = 2.9
        corona.stretchFactor = 0.087
        corona.particleColor = myStar.color
        corona.particleSize = 0.001
        corona.blendMode = .additive
        let starParticle = SCNParticleSystem()
        starParticle.birthRate = 25
        starParticle.birthDirection = .random
        starParticle.emitterShape = myStar.node.geometry
        starParticle.particleLifeSpan = 11
        starParticle.particleVelocity = 0.1
        starParticle.stretchFactor = 0.1
        starParticle.particleColor = myStar.color
        starParticle.particleSize = 0.001
        starParticle.blendMode = .additive
        
        myStar.node.addParticleSystem(corona)
        myStar.node.addParticleSystem(starParticle)
        
    }
    
    @objc func reloadStar() {
        sceneView.scene?.rootNode.addChildNode(myStar.node)
        myStar.node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(myStar.rotationSpeed), z: 0, duration: 1)))
        energyBar.progress = 1
        createLifeTimer()
    }
    
    func newText(_ text: String) {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let x = Int.random(in: 20..<Int(width) - 120)
        let y = Int.random(in: 240..<Int(height) - 240)
        let label = UILabel(frame: CGRect(x: x, y: y, width: 100, height: 30))
        label.textColor = .white
        label.font = .roundedFont(ofSize: 18, weight: .black)
        label.text = "+\(text)"
        view.addSubview(label)
        UIView.animate(withDuration: 1, animations: {
            label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y - 60, width: label.frame.width, height: label.frame.height)
            label.layer.opacity = 0
        }) { _ in
            label.removeFromSuperview()
        }
    }
    
    @objc func fireLifeTimer() {
        if myStar.isAlive {
            if myStar.energy - myStar.fuseRate >= 0 {
                myStar.energy -= myStar.fuseRate
                energyBar.progress = Float(myStar.energy / myStar.maxEnergy)
            } else {
                myStar.isAlive = false
                myStar.energy = 0
                energyBar.progress = 0
                myStar.die()
                lifeTimer.invalidate()
            }
        } else {
            lifeTimer.invalidate()
        }
    }
    
    @objc func fireAutoTimer() {
        if myStar.isAlive {
            myPlayer.energy += myStar.fuseRate
            newText(myStar.fuseRate.abbreviated)
            updateLabels()
        }
    }
    
    @objc func updateLabels() {
        energyLabel.text = myPlayer.energy.abbreviated
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        if myStar.isAlive {
            myPlayer.energy += myPlayer.boostValue
            myStar.energy -= myPlayer.boostValue / 4
            newText(myPlayer.boostValue.abbreviated)
            updateLabels()
            // check what nodes are tapped
            let p = gestureRecognize.location(in: sceneView)
            let hitResults = sceneView.hitTest(p, options: [:])
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result = hitResults[0]
                // highlight it
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.1
                // on completion - unhighlight
                SCNTransaction.completionBlock = {
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.1
                    result.node.particleSystems?[1].birthRate = 25
                    //result.node.geometry?.firstMaterial?.emission.contents = self.myStar.color
                    SCNTransaction.commit()
                }
                result.node.particleSystems?[1].birthRate = 1_000
                //result.node.geometry?.firstMaterial?.emission.contents = UIColor.darkGray
                SCNTransaction.commit()
            }
        } else {
            let val = myPlayer.boostValue / 10
            myPlayer.energy += val
            newText(val.abbreviated)
            updateLabels()
            // check what nodes are tapped
            let p = gestureRecognize.location(in: sceneView)
            let hitResults = sceneView.hitTest(p, options: [:])
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result = hitResults[0]
                // highlight it
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.1
                // on completion - unhighlight
                SCNTransaction.completionBlock = {
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.1
                    result.node.particleSystems?[1].birthRate = 8
                    //result.node.geometry?.firstMaterial?.emission.contents = self.myStar.color
                    SCNTransaction.commit()
                }
                result.node.particleSystems?[1].birthRate = 100
                //result.node.geometry?.firstMaterial?.emission.contents = UIColor.darkGray
                SCNTransaction.commit()
            }
        }
    }
    
    @objc func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        if playerData.isEmpty {
            let data = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "PlayerData", in: managedContext)!, insertInto: managedContext)
            playerData.append(data)
        }
        if starData.isEmpty {
            let data = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "StarData", in: managedContext)!, insertInto: managedContext)
            starData.append(data)
        }
        playerData[0].setValue(myPlayer.energy, forKey: "energy")
        playerData[0].setValue(myPlayer.boostValue, forKey: "boostValue")
        starData[0].setValue(Float(myStar.color.components.red), forKey: "colorr")
        starData[0].setValue(Float(myStar.color.components.green), forKey: "colorg")
        starData[0].setValue(Float(myStar.color.components.blue), forKey: "colorb")
        starData[0].setValue(myStar.zams, forKey: "zams")
        starData[0].setValue(myStar.rotationSpeed, forKey: "rotationSpeed")
        starData[0].setValue(myStar.isAlive, forKey: "isAlive")
        starData[0].setValue(myStar.name, forKey: "name")
        starData[0].setValue(myStar.fuseRate, forKey: "fuseRate")
        starData[0].setValue(myStar.energy, forKey: "energy")
        starData[0].setValue(myStar.maxEnergy, forKey: "maxEnergy")
        starData[0].setValue(myStar.node.scale.x, forKey: "scalex")
        starData[0].setValue(myStar.node.scale.y, forKey: "scaley")
        starData[0].setValue(myStar.node.scale.z, forKey: "scalez")
        
        do {
            try managedContext.save()
            def.set(true, forKey: "has_saved_data")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
