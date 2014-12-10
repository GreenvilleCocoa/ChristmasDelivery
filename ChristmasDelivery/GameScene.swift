//
//  GameScene.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var theSleigh: LoadedSleigh?
    var levelScore: Int = 0 {
        didSet {
            self.adjustScoreLabel()
        }
    }
    let level: Int
    let backgroundLayer: SKNode = SKNode()
    let buildingLayer: SKNode = SKNode()
    let sleighLayer: SKNode = SKNode()
    let overLayer: SKNode = SKNode()
    let scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    var gameIsOver: Bool = false
    
    var lastBuilding: Building?
    var distanceToNextBuilding: CGFloat = 50
    
    var nextHazardPosition: CGFloat = -1200
    
    init(size: CGSize, level: Int) {
        self.level = level
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, stop calling it")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let gameHeight = self.size.height
        
        let snowHeight = gameHeight * 0.1
        
        let backgroundTexture = SKTexture(imageNamed: "NightSky.png")
        let backgroundImageSprite = SKSpriteNode(texture: backgroundTexture)
        backgroundImageSprite.size = view.frame.size
        backgroundImageSprite.size.height -= snowHeight
        backgroundImageSprite.anchorPoint = CGPoint.zeroPoint
        
        let snowTexture = SKTexture(imageNamed: "snow.png")
        let snowSprite = SKSpriteNode(texture: snowTexture)
        snowSprite.size = CGSize(width: backgroundImageSprite.size.width, height: snowHeight)
        snowSprite.anchorPoint = CGPoint.zeroPoint
        
        self.addChild(backgroundImageSprite)
        backgroundImageSprite.position = CGPoint(x: 0, y: snowHeight)
        
        self.addChild(snowSprite)
        
        self.addChild(backgroundLayer)
        self.addChild(buildingLayer)
        self.addChild(sleighLayer)
        self.addChild(overLayer)
        
        let treeHeight = size.height / 10.0
        let treeDistance = size.width / 5.0
        let treeWidth = size.width / 30.0
        
        for i in 1...8 {
            let aTree = Tree(size: CGSize(width: treeHeight, height: treeWidth * 3.0))
            backgroundLayer.addChild(aTree)
            aTree.position = CGPoint(x: treeDistance * CGFloat(i), y: treeHeight)
        }
        
        scoreLabel.fontSize = 32.0
        overLayer.addChild(scoreLabel)
        self.adjustScoreLabel()
        
        theSleigh = LoadedSleigh(size: CGSize(width: gameHeight / 5.0, height: gameHeight / 10.0))
        self.sleighLayer.addChild(theSleigh!)
        theSleigh!.position = CGPoint(x: gameHeight / 5.0, y: 100)
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -8.0)
        self.physicsWorld.contactDelegate = self
        let edgeRect: CGRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height + 100)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: edgeRect)
        self.physicsBody!.categoryBitMask = PhysicsCategory.EdgeLoop
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Present|PhysicsCategory.Santa|PhysicsCategory.Sleigh|PhysicsCategory.Reindeer
        
        self.addNewBuilding()
    }
    
    // MARK: Game Flow
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let presentNode: SKNode? = self.childNodeWithName("present")
        
        if theSleigh!.presents.count <= 0 && presentNode == nil && !gameIsOver {
            // There are no more presents, the level is over
            self.levelEnded(false)
        }
        
        // Move the buildings and background
        backgroundLayer.position.x -= ((CGFloat(level) + 2) * 0.5)
        buildingLayer.position.x -= 2 + CGFloat(level)
        
        if let theLastBuilding = lastBuilding {
            let pointInScene = self.convertPoint(theLastBuilding.position, fromNode: buildingLayer)
            
            if (pointInScene.x + (theLastBuilding.size.width / 2.0)) < (size.width - distanceToNextBuilding) {
                self.addNewBuilding()
            }
        }
        
        if (buildingLayer.position.x < nextHazardPosition) {
            if let theLastBuilding = lastBuilding {
                if theLastBuilding.type != .ClockTower {
                    self.addNewAirHazard()
                }
            }
            
            let nextDistance: CGFloat = 1000.0 + CGFloat(arc4random_uniform(UInt32((40 - level) * 10)))
            nextHazardPosition -= nextDistance
        }
        
        // Check the trees, if they are off the screen to the left, move them back to the right
        self.backgroundLayer.enumerateChildNodesWithName("tree", usingBlock: {
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            // do something with node or stop
            let positionInScene = self.convertPoint(node.position, fromNode: node.parent!)
            if positionInScene.x < -100 {
                let random = CGFloat(arc4random_uniform(500)) + 1200
                node.position.x += random
            }
        })
    }
    
    func levelEnded(died: Bool) {
        var success = false
        
        if levelScore > 5 {
            success = true
        }
        
        if died {
            success = false
        }
        
        gameIsOver = true
        
        let delay = 2 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) { [weak self] () -> Void in
            if self != nil {
                let scene: GameOverScene = GameOverScene(size: self!.size, success: success, level: self!.level)
                scene.scaleMode = .AspectFill
                
                self!.view!.presentScene(scene)
            }
        }
        
        
    }
    
    // MARK: Touches
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        var moveTouch: UITouch?
        var foundMoveTouch = false
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if location.x <= (size.height / 5.0) + (theSleigh!.size.width / 2.0) {
                theSleigh!.dropPresent()
            }
            else {
                if !foundMoveTouch {
                    moveTouch = touch as? UITouch
                    foundMoveTouch = true
                }
            }
        }
        
        if let foundTouch = moveTouch {
            let height = foundTouch.locationInNode(self).y
            theSleigh!.moveToHeight(height)
        }
    }
    
    // MARK: SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        var body1: SKPhysicsBody = contact.bodyA
        var body2: SKPhysicsBody = contact.bodyB
        
        // Sort the nodes so that we don't have to check both bodies every time
        if body2.categoryBitMask < body1.categoryBitMask {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategory.Present && (body2.categoryBitMask == PhysicsCategory.Hazard || body2.categoryBitMask == PhysicsCategory.EdgeLoop) {
            if let thePresent: Present = body1.node as? Present {
                let presentLocation = self.convertPoint(thePresent.position, fromNode: thePresent.parent!)
                
                thePresent.removeFromParent()
                thePresent.physicsBody = nil
                
                if let index = find(theSleigh!.presents, thePresent) {
                    theSleigh!.presents.removeAtIndex(index)
                }
                
                self.makeExplosionAtPoint(presentLocation, withFire: true)
            }
            
            return
        }
        
        if body1.categoryBitMask == PhysicsCategory.Present && body2.categoryBitMask == PhysicsCategory.Chimney {
            if let thePresent: Present = body1.node as? Present {
                thePresent.removeFromParent()
                thePresent.physicsBody = nil
                
                if let index = find(theSleigh!.presents, thePresent) {
                    theSleigh!.presents.removeAtIndex(index)
                }
            }
            
            let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.text = "+\(level)";
            scoreLabel.fontSize = 32;
            let positionInScene = contact.contactPoint
            let positionInBuildingLayer = self.convertPoint(positionInScene, toNode: buildingLayer)
            
            let riseAction = SKAction.moveByX(0.0, y: 100, duration: 1.0)
            let waitAction = SKAction.waitForDuration(0.5)
            let fadeAction = SKAction.fadeAlphaTo(0, duration: 0.5)
            let fadeSequence = SKAction.sequence([waitAction, fadeAction, SKAction.removeFromParent()])
            let totalAction = SKAction.group([fadeSequence, riseAction])
            
            buildingLayer.addChild(scoreLabel)
            scoreLabel.position = positionInBuildingLayer
            scoreLabel.runAction(totalAction)
            
            totalScore += level
            levelScore += 1
            
            return
        }
        
        if body1.categoryBitMask == PhysicsCategory.Reindeer && (body2.categoryBitMask == PhysicsCategory.Hazard || body2.categoryBitMask == PhysicsCategory.Chimney) {
            if let theReindeer = body1.node as? Reindeer {
                let positionInScene = self.convertPoint(theReindeer.position, fromNode: theReindeer.parent!)
                if let index = find(theSleigh!.sleighComponents, theReindeer) {
                    theSleigh!.sleighComponents.removeAtIndex(index)
                    theReindeer.removeFromParent()
                    overLayer.addChild(theReindeer)
                    theReindeer.physicsBody!.affectedByGravity = true
                    theReindeer.physicsBody!.contactTestBitMask = PhysicsCategory.EdgeLoop
                    
                    if theSleigh!.sleighComponents.count < 2 {
                        self.dropTheSleigh()
                    }
                }
                
                if let theHazard = body2.node  {
                    if theHazard.name == "airHazard" {
                        self.makeExplosionAtPoint(positionInScene, withFire: false)
                        theHazard.removeFromParent()
                    }
                }
            }
            
            return
        }
        
        if body1.categoryBitMask == PhysicsCategory.Reindeer && body2.categoryBitMask == PhysicsCategory.EdgeLoop {
            if let theReindeer = body1.node as? Reindeer {
                let positionInScene = self.convertPoint(theReindeer.position, fromNode: theReindeer.parent!)
                theReindeer.removeFromParent()
                theReindeer.physicsBody = nil
                
                if let index = find(theSleigh!.sleighComponents, theReindeer) {
                    theSleigh!.sleighComponents.removeAtIndex(index)
                }
                
                self.makeExplosionAtPoint(positionInScene, withFire: true)
            }
        }
        
        if body1.categoryBitMask == PhysicsCategory.Sleigh && (body2.categoryBitMask == PhysicsCategory.Hazard || body2.categoryBitMask == PhysicsCategory.Chimney || body2.categoryBitMask == PhysicsCategory.EdgeLoop) {
            self.dropTheSleigh()
        }
    }
    
    // MARK: Other
    
    func makeExplosionAtPoint(point: CGPoint, withFire: Bool) {
        let explosionEmitter = Explosion(color: UIColor.redColor())
        overLayer.addChild(explosionEmitter)
        explosionEmitter.position = point
        
        if withFire {
            let fire = FireEmitter.emitternode()
            buildingLayer.addChild(fire)
            fire.position = self.convertPoint(CGPoint(x: point.x, y: point.y - 20.0), toNode: buildingLayer)
        }
    }
    
    func addNewBuilding() {
        
        // Get a random int between 0 and 99, determine the building based on level, more chimney houses early, more towers later
        let random: UInt32 = arc4random_uniform(100)
        
        let towerChance: UInt32 = 10 + level
        let chimneyChance: UInt32 = min(90, 60 + level)
        
        var type: BuildingType?
        
        switch random {
        case 0...towerChance:
            type = .ClockTower
        case chimneyChance...100:
            type = .HouseWithChimney
        default:
            type = .House
        }
        
        let building = Building(type: type!, width: type! == .ClockTower ? size.width / 8.0 : size.width / 6.0)
        
        buildingLayer.addChild(building)
        let positionInScene = CGPoint(x: size.width + (building.size.width / 2.0), y: (building.size.height / 2.0))
        building.position = buildingLayer.convertPoint(positionInScene, fromNode: self)
        
        lastBuilding = building
        
        distanceToNextBuilding = 20 + CGFloat(arc4random_uniform(81))
    }
    
    func addNewAirHazard() {
        let width: CGFloat = size.height / 8.0
        let hazardSize = CGSize(width: width, height: width * 2.0)
        
        let aHazard = AirHazard(size: hazardSize)
        self.buildingLayer.addChild(aHazard)
        
        // Pick a height just above the house line
        let randomHeight = size.width * 0.25 + CGFloat(arc4random_uniform(UInt32(size.height - (size.width * 0.25)))) - 50
        let offScreenX = size.width + width
        let scenePoint = CGPoint(x: offScreenX, y: randomHeight)
        let buildingPoint = self.convertPoint(scenePoint, toNode: buildingLayer)
        
        aHazard.position = buildingPoint
    }
    
    func adjustScoreLabel() {
        scoreLabel.text = "Score: \(totalScore)"
        let scorePosition = CGPoint(x: (scoreLabel.frame.size.width / 2.0) + 10, y: size.height - (scoreLabel.frame.size.height / 2.0) - 10)
        scoreLabel.position = scorePosition
    }
    
    func dropTheSleigh() {
        theSleigh!.santa.physicsBody!.affectedByGravity = true
        
        for present in theSleigh!.presents {
            present.physicsBody!.affectedByGravity = true
        }
        
        for sleighComponent in theSleigh!.sleighComponents {
            sleighComponent.physicsBody!.affectedByGravity = true
        }
        
        if !gameIsOver {
            self.levelEnded(true)
        }
    }
    
}
