//
//  Building.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import SpriteKit

class Building: SKSpriteNode {
    let type: BuildingType
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize, type: BuildingType) {
        self.type = type
        super.init(texture: texture, color: color, size: size)
        name = "building"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, stop calling it")
    }
    
    convenience init(type: BuildingType, buildingSize: CGSize) {
        var textureName: String?
        
        switch type {
        case .House:
            textureName = "house.png"
        case .HouseWithChimney:
            textureName = "house.png"
        case .ClockTower:
            textureName = "clockTower.png"
        }
        
        let texture = SKTexture(imageNamed: textureName!)
        
        self.init(texture: texture, color: UIColor.clearColor(), size: buildingSize, type: type)
        self.physicsBody = SKPhysicsBody(texture: texture, size: buildingSize)
        self.physicsBody!.categoryBitMask = PhysicsCategory.Hazard
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Present|PhysicsCategory.Santa|PhysicsCategory.Sleigh|PhysicsCategory.Reindeer
        self.physicsBody!.dynamic = false
        self.physicsBody!.affectedByGravity = false
        
        if type == .HouseWithChimney {
            let chimneySize: CGSize = CGSize(width: buildingSize.width / 5.0, height: buildingSize.height / 2.0)
            print("Chimney size \(chimneySize)")
            let chimney = SKSpriteNode(imageNamed: "chimney.png")
            chimney.size = chimneySize
            chimney.physicsBody = SKPhysicsBody(rectangleOfSize: chimneySize)
            chimney.physicsBody!.categoryBitMask = PhysicsCategory.Chimney
            chimney.physicsBody!.contactTestBitMask = PhysicsCategory.Present|PhysicsCategory.Santa|PhysicsCategory.Sleigh|PhysicsCategory.Reindeer
            chimney.physicsBody!.affectedByGravity = false
            chimney.physicsBody!.dynamic = false
            self.addChild(chimney)
            chimney.position = CGPoint(x: buildingSize.width / 4.0, y: buildingSize.height / 2.0)
        }
        
    }
}
