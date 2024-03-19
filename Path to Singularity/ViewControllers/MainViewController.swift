//
//  MainViewController.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 3/30/21.
//

import UIKit
import SceneKit
import SwiftUI

struct MainView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainViewController {
        let viewModel = MainSceneViewModel(
            playerDataController: PlayerDataController(),
            starDataController: StarDataController()
        )
        return MainViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
        
    }
}

final class MainViewController: UIViewController, SCNSceneRendererDelegate {
    
    var sceneView = SCNView()
    
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
        .lightContent
    }
    
    let viewModel: MainSceneViewModel
    
    init(viewModel: MainSceneViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        sceneView.delegate = self
        viewModel.eventsController.delegate = self
        activateConstraints()
        createViews()
        setScene()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneView.frame = view.bounds
    }
        
    func activateConstraints() {
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
        sceneView.preferredFramesPerSecond = 120
        sceneView.scene = SCNScene(named: "art.scnassets/MainScene.scn")!
        sceneView.scene?.physicsWorld.gravity = SCNVector3Zero
        sceneView.scene?.rootNode.childNode(
            withName: "camera",
            recursively: true
        )?.position = SCNVector3(0, 1.4, 4)
        
        sceneView.scene?.rootNode.addChildNode(viewModel.myStar.node)
        viewModel.myStar.node.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(
                    x: 0,
                    y: CGFloat(viewModel.myStar.rotationSpeed),
                    z: 0,
                    duration: 1
                )
            )
        )
        if viewModel.myStar.zams > 25 && !viewModel.myStar.isAlive {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.viewModel.myStar.performSuperNova()
            }
        }
    }
    
    func createViews() {
        energyLabel.font = .roundedFont(ofSize: 22, weight: .bold)
        energyBar.progress = Float(viewModel.myStar.energy / viewModel.myStar.maxEnergy)
        updateLabels()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLabels),
            name: NSNotification.Name(rawValue: "updateLabels"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadStar),
            name: NSNotification.Name(rawValue: "reloadStar"),
            object: nil
        )
    }
    
    @objc func reloadStar() {
        sceneView.scene?.rootNode.addChildNode(viewModel.myStar.node)
        viewModel.myStar.node.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(
                    x: 0,
                    y: CGFloat(viewModel.myStar.rotationSpeed),
                    z: 0,
                    duration: 1
                )
            )
        )
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
        energyLabel.text = viewModel.myPlayer.energy.abbreviated
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        if viewModel.myStar.isAlive {
            viewModel.myPlayer.energy += viewModel.myPlayer.boostValue
            viewModel.myStar.energy -= viewModel.myPlayer.boostValue / 4
            newText(viewModel.myPlayer.boostValue.abbreviated)
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
                    result.node.particleSystems?[1].birthRate = 400
                    //result.node.geometry?.firstMaterial?.emission.contents = self.myStar.color
                    SCNTransaction.commit()
                }
                result.node.particleSystems?[1].birthRate = 4_000
                //result.node.geometry?.firstMaterial?.emission.contents = UIColor.darkGray
                SCNTransaction.commit()
            }
        } else {
            let val = viewModel.myPlayer.boostValue / 10
            viewModel.myPlayer.energy += val
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
        if viewModel.myStar.isAlive {
            if viewModel.myStar.energy - viewModel.myStar.fuseRate >= 0 {
                viewModel.myStar.energy -= viewModel.myStar.fuseRate
                energyBar.progress = Float(viewModel.myStar.energy / viewModel.myStar.maxEnergy)
            } else {
                viewModel.myStar.isAlive = false
                viewModel.myStar.energy = 0
                energyBar.progress = 0
                viewModel.myStar.die()
                timer.invalidate()
            }
        } else {
            timer.invalidate()
        }
    }
    
    func autoTimerFired(timer: Timer) {
        if viewModel.myStar.isAlive {
            viewModel.myPlayer.energy += viewModel.myStar.fuseRate
            newText(viewModel.myStar.fuseRate.abbreviated)
            updateLabels()
        }
    }
    
    func saveTimerFired(timer: Timer) {
        viewModel.saveData()
    }
    
}
