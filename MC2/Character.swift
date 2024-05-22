//
//  Character.swift
//  MC2
//
//  Created by Jovani Liman on 22/05/24.
//

import Foundation
import SceneKit
import simd

class Character: NSObject {
    
    static private let speedFactor: CGFloat = 2.0
    static private let stepsCount = 10

    static private let initialPosition = float3(0.1, -0.2, 0)
    
    // some constants
    static private let gravity = Float(0.004)
    static private let jumpImpulse = Float(0.1)
    static private let minAltitude = Float(-10)
    static private let enableFootStepSound = true
    static private let collisionMargin = Float(0.04)
    static private let modelOffset = float3(0, -collisionMargin, 0)
    static private let collisionMeshBitMask = 8
}
