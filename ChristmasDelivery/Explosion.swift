//
//  Explosion.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import SpriteKit

class Explosion: SKEmitterNode {
    init(color: UIColor) {
        super.init()
        self.particleTexture = SKTexture(imageNamed: "spark.png")
        self.particleColor = color
        self.numParticlesToEmit = 200
        self.particleBirthRate = 4500
        self.particleLifetime = 2
        self.emissionAngleRange = 360
        self.particleSpeed = 1000
        self.particleSpeedRange = 500
        self.xAcceleration = 0
        self.yAcceleration = 0
        self.particleAlpha = 0.8
        self.particleAlphaRange = 0.2
        self.particleAlphaSpeed = -1
        self.particleScale = 0.75
        self.particleScaleRange = 0.4
        self.particleScaleSpeed = -1
        self.particleRotation = 0
        self.particleRotationRange = 0
        self.particleRotationSpeed = 0
        
        self.particleColorBlendFactor = 1
        self.particleColorBlendFactorRange = 0
        self.particleColorBlendFactorSpeed = 0
        self.particleBlendMode = SKBlendMode.Add
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, and won't be. Ever.")
    }
    
    
}
