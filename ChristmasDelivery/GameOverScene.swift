//
//  GameOverScene.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    let success: Bool
    let level: Int
    
    init(size: CGSize, success: Bool, level: Int) {
        self.success = success
        self.level = level
        
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, stop calling it")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel
        
        if success {
            myLabel.text = "Completed Level \(level)!";
        }
        else {
            myLabel.text = "Game Over, score \(totalScore)!";
        }
        
        myLabel.fontSize = 44;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if !success {
            totalScore = 0
        }
        
        let nextLevel: Int = success ? level + 1 : 1
        
        let scene: GameScene = GameScene(size: size, level: nextLevel)
        scene.scaleMode = .AspectFill
        
        view!.presentScene(scene)
    }
}
