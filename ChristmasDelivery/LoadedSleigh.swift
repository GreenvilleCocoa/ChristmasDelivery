//
//  LoadedSleigh.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import SpriteKit

class LoadedSleigh: SKNode {
    var sleighComponents: [SleighComponent] = []
    var theSleigh: Sleigh {
        get {
            return sleighComponents[0] as! Sleigh
        }
    }
    
    let santa: Santa
    var presents: [Present] = []
    var size: CGSize = CGSize.zeroSize
    var spaceBetweenComponents: CGFloat {
        get {
            return theSleigh.size.width * 0.05
        }
    }
    
    var climbingSpeed: CGFloat {
        get {
            return theSleigh.size.height * 4 * (CGFloat(sleighComponents.count) / 5.0)
        }
    }
    
    var targetHeight: CGFloat = 0.0
    override var position: CGPoint {
        didSet {
            self.targetHeight = position.y
        }
    }
    
    init(size: CGSize) {
        self.size = size
        let santaSize = CGSize(width: size.width / 4.0, height: size.height * 1.5)
        self.santa = Santa(size: santaSize)
        super.init()
        let aSleigh = Sleigh(size: size)
        sleighComponents.append(aSleigh)
        
        for _ in 0...3 {
            self.addReindeer()
        }
        
        let presentSize = CGSize(width: size.width / 6.0, height: size.width / 6.0)
        for _ in 0...9 {
            let present = Present(size: presentSize)
            self.presents.append(present)
        }
        
        for i in 0...9 {
            self.addChild(self.presents[9 - i])
        }
        
        let startingPresentY: CGFloat = (size.height / 2.0)
        let middlePresentX = size.width * -0.3
//        let presentHeightOffset = (presentSize.height * presentBowPercentage)
        
        self.presents[9].position = CGPoint(x: middlePresentX + (presentSize.width / 2.0), y: startingPresentY + (presentSize.height * 1.8))
        self.presents[8].position = CGPoint(x: middlePresentX + presentSize.width, y: startingPresentY + (presentSize.height * 0.95))
        self.presents[7].position = CGPoint(x: middlePresentX, y: startingPresentY + (presentSize.height * 1.20))
        self.presents[6].position = CGPoint(x: middlePresentX + (presentSize.width * 1.5), y: startingPresentY + (presentSize.height * 0.1))
        self.presents[5].position = CGPoint(x: middlePresentX + (presentSize.width / 2.0), y: startingPresentY + (presentSize.height * 0.35))
        self.presents[4].position = CGPoint(x: middlePresentX - (presentSize.width / 2.0), y: startingPresentY + (presentSize.height * 0.6))
        self.presents[3].position = CGPoint(x: middlePresentX + presentSize.width * 2, y: startingPresentY - presentSize.height * 0.75)
        self.presents[2].position = CGPoint(x: middlePresentX + presentSize.width, y: startingPresentY - (presentSize.height / 2.0))
        self.presents[1].position = CGPoint(x: middlePresentX, y: startingPresentY - (presentSize.height / 4.0))
        self.presents[0].position = CGPoint(x: middlePresentX - presentSize.width, y: startingPresentY)
        
        self.addChild(self.santa)
        self.santa.position = CGPoint(x: santa.size.width / 2.0, y: santa.size.height * 0.45)
        self.addChild(aSleigh)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, stop calling it")
    }
    
    func addReindeer() {
        let previousSleighComponent = sleighComponents.last!
        let reindeerSize = CGSize(width: size.width / 2.0, height: size.height)
        let reindeerPosition = CGPoint(x: previousSleighComponent.position.x + (previousSleighComponent.size.width / 2.0) + (reindeerSize.width / 2.0) + spaceBetweenComponents, y: previousSleighComponent.position.y)
        
        let aReindeer: Reindeer = Reindeer(size: reindeerSize)
        self.addChild(aReindeer)
        aReindeer.position = reindeerPosition
        
        //TODO: use joint to connect to previous sleigh component
        
        sleighComponents.append(aReindeer)
    }
    
    func moveToHeight(height: CGFloat) {
        let dY = height - targetHeight
        targetHeight = height
        let distance = fabs(dY)
        let time: NSTimeInterval = NSTimeInterval(distance / climbingSpeed)
        
        self.climbByHeight(dY, time: time)
    }
    
    func climbByHeight(dY: CGFloat, time: NSTimeInterval) {
        let fallAction: SKAction = self.makeClimbAction(-dY, time: time, sleighComponentPosition: Int(sleighComponents.count - 1))
        
        if sleighComponents.count > 1 {
            for reindeerPosition in 0...(sleighComponents.count - 2) {
                let reindeer: Reindeer = sleighComponents[(sleighComponents.count) - reindeerPosition - 1] as! Reindeer
                let climbAction = self.makeClimbAction(dY, time: time, sleighComponentPosition: reindeerPosition)
                reindeer.runAction(climbAction)
                reindeer.runAction(fallAction)
            }
        }
        
        let sleighClimbAction = self.makeClimbAction(dY, time: time, sleighComponentPosition: Int(sleighComponents.count - 1))
        self.runAction(sleighClimbAction)
    }
    
    func makeClimbAction(dy: CGFloat, time: NSTimeInterval, sleighComponentPosition: Int) -> SKAction {
        let numberOfSleighComponents = CGFloat(sleighComponents.count)
        let climbTime = NSTimeInterval((numberOfSleighComponents - 1) * 0.2) * time
        let waitTime = NSTimeInterval(CGFloat(sleighComponentPosition) * 0.2) * time
        
        let waitAction = SKAction.waitForDuration(waitTime)
        let climbAction = SKAction.moveByX(0, y: dy, duration: climbTime)
        
        let sequenceAction = SKAction.sequence([waitAction, climbAction])

        return sequenceAction
    }
    
    func dropPresent() {
        if presents.count < 1 {
            return
        }
        let present = presents.removeLast()
        let santaPositionInScene = self.scene!.convertPoint(santa.position, fromNode: santa.parent!)
        present.removeFromParent()
        self.scene!.addChild(present)
        present.physicsBody!.affectedByGravity = true
        present.position = santaPositionInScene
    }
}
