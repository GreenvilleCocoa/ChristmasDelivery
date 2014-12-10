//
//  Santa.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import SpriteKit

class Santa: SKSpriteNode {
    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "santa.png")
        super.init(texture: texture, color: UIColor.clearColor(), size: size)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width * 0.95, height: size.height * 0.95))
        self.physicsBody!.categoryBitMask = PhysicsCategory.Santa
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Chimney|PhysicsCategory.Hazard|PhysicsCategory.EdgeLoop
        self.physicsBody!.collisionBitMask = PhysicsCategory.Chimney|PhysicsCategory.Hazard|PhysicsCategory.EdgeLoop
        self.physicsBody!.affectedByGravity = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, stop calling it")
    }
}
