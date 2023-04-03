//
//  WeatherEffectManager.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-31.
//

import Foundation
import SpriteKit

class WeatherEffectManager {
    private static var _rainFallEffect: SKScene?
    private static var _rainFallLandingEffect: SKScene?
    private static var _rainFallLandingBottomEffect: SKScene?
    
    static var rainFallEffect: SKScene {
        if _rainFallEffect == nil {
            _rainFallEffect = RainFall()
        }
        return _rainFallEffect!
    }
    
    static var rainFallLandingEffect: SKScene {
        if _rainFallLandingEffect == nil {
            _rainFallLandingEffect = RainFallLanding()
        }
        return _rainFallLandingEffect!
    }
    
    static var rainFallLandingBottomEffect: SKScene {
        if _rainFallLandingBottomEffect == nil {
            _rainFallLandingBottomEffect = RainFallLandingBottom()
        }
        return _rainFallLandingBottomEffect!
    }
}
