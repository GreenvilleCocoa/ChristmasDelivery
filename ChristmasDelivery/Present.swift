//
//  Present.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import SpriteKit

let presentBowPercentage: CGFloat = 0.05

class Present: SKSpriteNode {
    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "present.png")
        super.init(texture: texture, color: UIColor.clearColor(), size: size)
        self.name = "present"
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width * 0.95, height: size.height * (0.95 - presentBowPercentage)), center: CGPoint(x: 0, y: (presentBowPercentage / -2.0)))
        self.physicsBody!.categoryBitMask = PhysicsCategory.Present
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Chimney|PhysicsCategory.Hazard|PhysicsCategory.EdgeLoop
        self.physicsBody!.collisionBitMask = PhysicsCategory.Chimney|PhysicsCategory.Hazard|PhysicsCategory.EdgeLoop        
        self.physicsBody!.affectedByGravity = false

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, stop calling it")
    }
}
