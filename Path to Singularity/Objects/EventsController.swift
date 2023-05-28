//
//  EventsController.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 9/28/22.
//

import Foundation

protocol EventsControllerDelegate: AnyObject {
    func lifeTimerFired(timer: Timer)
    func autoTimerFired(timer: Timer)
    func saveTimerFired(timer: Timer)
}

class EventsController: ObservableObject {
    
    var lifeTimer: Timer!
    var autoTimer: Timer!
    var saveTimer: Timer!
    
    weak var delegate: EventsControllerDelegate?
    
    init() {
        createAutoTimer()
        createLifeTimer()
        createSaveTimer()
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
        saveTimer = Timer(timeInterval: 5, target: self, selector: #selector(fireSaveTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(saveTimer, forMode: .common)
    }
    
    @objc func fireLifeTimer() {
        delegate?.lifeTimerFired(timer: lifeTimer)
    }
    
    @objc func fireAutoTimer() {
        delegate?.autoTimerFired(timer: autoTimer)
    }
    
    @objc func fireSaveTimer() {
        delegate?.saveTimerFired(timer: saveTimer)
    }
    
}
