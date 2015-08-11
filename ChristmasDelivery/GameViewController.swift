//
//  GameViewController.swift
//  ChristmasDelivery
//
//  Created by Marcus Smith on 12/8/14.
//  Copyright (c) 2014 GreenvilleCocoaheads. All rights reserved.
//

import UIKit
import SpriteKit

var totalScore: Int = 0

class GameViewController: UIViewController {
    
    override func loadView() {
        let skView = SKView()
        view = skView
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let skView: SKView = self.view as! SKView
        
        if (skView.scene == nil) {
            skView.showsFPS = true
            skView.showsNodeCount = true
//            skView.ignoresSiblingOrder = true
//            skView.showsPhysics = true
            
            let scene: GameScene = GameScene(size: skView.frame.size, level: 1)
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
}
