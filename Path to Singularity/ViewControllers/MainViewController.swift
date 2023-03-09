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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var viewModel: MainSceneViewModel
    
    init(viewModel: MainSceneViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.eventsController.delegate = self
        if def.bool(forKey: "has_saved_data") == true {
            viewModel.playerDataController.loadPlayerData()
            viewModel.starDataController.loadStarData()
            loadStar()
            createViews()
            setScene()
        } else {
            viewModel.createNewData()
            viewModel.starDataController.myStar.creatNode()
            createViews()
            setScene()
        }
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
    
    func setScene() {
        sceneView.scene?.physicsWorld.gravity = SCNVector3Zero
        sceneView.allowsCameraControl = true
        sceneView.scene?.rootNode.childNode(withName: "camera", recursively: true)?.position = SCNVector3(0, 1.4, 4)
        sceneView.scene = SCNScene(named: "art.scnassets/MainScene.scn")
        sceneView.scene?.rootNode.addChildNode(viewModel.starDataController.myStar.node)
        viewModel.starDataController.myStar.node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(viewModel.starDataController.myStar.rotationSpeed), z: 0, duration: 1)))
    }
    
    func createViews() {
        energyLabel.font = .roundedFont(ofSize: 22, weight: .bold)
        energyBar.progress = Float(viewModel.starDataController.myStar.energy / viewModel.starDataController.myStar.maxEnergy)
        updateLabels()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: NSNotification.Name(rawValue: "updateLabels"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStar), name: NSNotification.Name(rawValue: "reloadStar"), object: nil)
    }
    
    func loadStar() {
        let scalex = viewModel.starDataController.getStarData("scalex") as! Float
        let scaley = viewModel.starDataController.getStarData("scaley") as! Float
        let scalez = viewModel.starDataController.getStarData("scalez") as! Float
        viewModel.starDataController.myStar.node = SCNNode(geometry: SCNSphere(radius: 0.3))
        viewModel.starDataController.myStar.node.scale = SCNVector3(scalex, scaley, scalez)
        viewModel.starDataController.myStar.node.light?.intensity = 2_300
        viewModel.starDataController.myStar.node.light?.type = .ambient
        let surface = SCNMaterial()
        let surfaceImage = UIImage(named: "gray1")?.withTintColor(viewModel.starDataController.myStar.color)
        surface.diffuse.contents = surfaceImage
        viewModel.starDataController.myStar.node.geometry?.insertMaterial(surface, at: 0)
        
        createCorona(star: viewModel.starDataController.myStar)
        createParticles(star: viewModel.starDataController.myStar)
        
    }
    
    func createCorona(star: Star) {
        let corona = SCNParticleSystem()
        corona.birthRate = 10_000
        corona.birthDirection = .random
        corona.emitterShape = star.node.geometry
        corona.particleLifeSpan = 1.5
        corona.particleVelocity = 0.03
        corona.speedFactor = 2.9
        corona.stretchFactor = 0.087
        corona.particleColor = star.color
        corona.particleSize = 0.001
        corona.blendMode = .additive
        star.node.addParticleSystem(corona)
    }
    
    func createParticles(star: Star) {
        let starParticle = SCNParticleSystem()
        starParticle.birthRate = 25
        starParticle.birthDirection = .random
        starParticle.emitterShape = star.node.geometry
        starParticle.particleLifeSpan = 11
        starParticle.particleVelocity = 0.1
        starParticle.stretchFactor = 0.1
        starParticle.particleColor = star.color
        starParticle.particleSize = 0.001
        starParticle.blendMode = .additive
        star.node.addParticleSystem(starParticle)
    }
    
    @objc func reloadStar() {
        sceneView.scene?.rootNode.addChildNode(viewModel.starDataController.myStar.node)
        viewModel.starDataController.myStar.node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(viewModel.starDataController.myStar.rotationSpeed), z: 0, duration: 1)))
        energyBar.progress = 1
        viewModel.eventsController.createLifeTimer()
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
    
    @objc func updateLabels() {
        energyLabel.text = myPlayer.energy.abbreviated
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        if viewModel.starDataController.myStar.isAlive {
            myPlayer.energy += myPlayer.boostValue
            viewModel.starDataController.myStar.energy -= myPlayer.boostValue / 4
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
    
}

extension MainViewController: EventsControllerDelegate {
    func lifeTimerFired(timer: Timer) {
        if viewModel.starDataController.myStar.isAlive {
            if viewModel.starDataController.myStar.energy - viewModel.starDataController.myStar.fuseRate >= 0 {
                viewModel.starDataController.myStar.energy -= viewModel.starDataController.myStar.fuseRate
                energyBar.progress = Float(viewModel.starDataController.myStar.energy / viewModel.starDataController.myStar.maxEnergy)
            } else {
                viewModel.starDataController.myStar.isAlive = false
                viewModel.starDataController.myStar.energy = 0
                energyBar.progress = 0
                viewModel.starDataController.myStar.die()
                timer.invalidate()
            }
        } else {
            timer.invalidate()
        }
    }
    
    func autoTimerFired(timer: Timer) {
        if viewModel.starDataController.myStar.isAlive {
            myPlayer.energy += viewModel.starDataController.myStar.fuseRate
            newText(viewModel.starDataController.myStar.fuseRate.abbreviated)
            updateLabels()
        }
    }
    
    func saveTimerFired(timer: Timer) {
        viewModel.playerDataController.saveData()
        viewModel.starDataController.saveData()
    }
    
}
