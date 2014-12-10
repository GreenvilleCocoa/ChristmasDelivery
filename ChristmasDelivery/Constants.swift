//
//  Constants.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import UIKit

struct PhysicsCategory {
    static let Present: UInt32 = 1 << 0
    static let Sleigh: UInt32 = 1 << 1
    static let Santa: UInt32 = 1 << 2
    static let Reindeer: UInt32 = 1 << 3
    static let Chimney: UInt32 = 1 << 4
    static let Hazard: UInt32 = 1 << 5
    static let EdgeLoop: UInt32 = 1 << 6
}

enum BuildingType {
    case House
    case HouseWithChimney
    case ClockTower
}