//
//  RainAnimation.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-29.
//

import Foundation
import SpriteKit

class RainFall: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "RainFall.sks")!
        addChild(node)
        
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}

class RainFallLanding: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "RainFallLanding.sks")!
        addChild(node)
        
        node.particlePositionRange.dx = 85
    }
}

class RainFallLandingBottom: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        anchorPoint = CGPoint(x: 0.5, y: 0)
        
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "RainFallLanding.sks")!
        addChild(node)
        
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}
