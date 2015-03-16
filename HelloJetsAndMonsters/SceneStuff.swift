//
//  SceneStuff.swift
//  Scene sks test
//
//  Created by Michael Jones on 23/02/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit


extension SKNode {
    class func UnarchiveSKSceneFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

extension SKLabelNode {
    func FadeNodeAwayToScene(nextScene:SKScene, view:SKView) {
    let fadeAway = SKAction.fadeOutWithDuration(2)
    self.runAction(fadeAway, completion: {
    let doors = SKTransition.doorwayWithDuration(1.0)
    nextScene.scaleMode = SKSceneScaleMode.AspectFill
    view.presentScene(nextScene, transition:doors)
    })
    }
    
    func FadeNodeInAndAwayToScene(nextScene:SKScene, view:SKView, text: NSString) {
        self.text = text
        FadeNodeInAndAwayToScene(nextScene, view: view)
    }

    func FadeNodeInAndAwayToScene(nextScene:SKScene, view:SKView) {
        let fadeIn = SKAction.fadeInWithDuration(1.0)
        let fadeAway = SKAction.fadeOutWithDuration(2)
        
        let fadeInAndAway = SKAction.sequence([fadeIn, fadeAway])
        self.runAction(fadeInAndAway, completion: {
            let doors = SKTransition.doorwayWithDuration(1.0)
            nextScene.scaleMode = SKSceneScaleMode.AspectFill
            view.presentScene(nextScene, transition:doors)
        })
    }
}

extension SKLabelNode {
    
    func FadeNodeInToScene(text: NSString) {
        let fadeIn = SKAction.fadeInWithDuration(1.0)
        self.text = text
        self.runAction(fadeIn)
    }
    
    func FadeNodeInAndOutOfScene(text: NSString) {
        let fadeIn = SKAction.fadeInWithDuration(1.0)
        let fadeAway = SKAction.fadeOutWithDuration(2.0)

        self.text = text
        self.runAction(SKAction.sequence([fadeIn, fadeAway]))
    }
}

