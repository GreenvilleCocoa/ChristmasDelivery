//
//  Tree.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/9/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import SpriteKit

class Tree: SKSpriteNode {
    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "christmasTree.png")
        super.init(texture: texture, color: UIColor.clearColor(), size: size)
        self.name = "tree"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
