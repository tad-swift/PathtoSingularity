//
//  SceneView.swift
//  Path to Singularity
//
//  Created by Tadreik Campbell on 3/19/23.
//

import SceneKit

final class SceneView: SCNView {
    override func hitTest(_ point: CGPoint, options: [SCNHitTestOption : Any]? = nil) -> [SCNHitTestResult] {
        // Check for the number of touches
        if let touches = self.gestureRecognizers?.compactMap({ $0.numberOfTouches }), touches.count > 1 {
            // If more than one touch, return an empty array
            return []
        }
        return super.hitTest(point, options: options)
    }
}
