//
//  AirHazard.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/9/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import SpriteKit

class AirHazard: SKSpriteNode {
    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "airHazard.png")
        super.init(texture: texture, color: UIColor.clearColor(), size: size)
        self.name = "airHazard"
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.3, center: CGPoint(x: 0.0, y: size.width * -0.45))
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.Hazard
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Present|PhysicsCategory.Santa|PhysicsCategory.Sleigh|PhysicsCategory.Reindeer
        self.physicsBody!.dynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, stop making me do this")
    }
}
