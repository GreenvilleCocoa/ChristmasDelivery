//
//  Reindeer.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import UIKit
import SpriteKit

class Reindeer: SleighComponent {
    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "reindeer.png")
        super.init(texture: texture, color: UIColor.clearColor(), size: size)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width * 0.8, height: size.height * 0.5))
        self.physicsBody!.categoryBitMask = PhysicsCategory.Reindeer
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Chimney|PhysicsCategory.Hazard|PhysicsCategory.EdgeLoop
        self.physicsBody!.collisionBitMask = PhysicsCategory.Chimney|PhysicsCategory.Hazard|PhysicsCategory.EdgeLoop
        self.physicsBody!.affectedByGravity = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//