//
//  FireEmitter.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import SpriteKit

class FireEmitter: SKEmitterNode {
    class func emitternode() -> SKEmitterNode {
        let untypedEmitter : AnyObject = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("fire", ofType: "sks")!)!;
        return untypedEmitter as SKEmitterNode
    }
}
