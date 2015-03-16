//
//  AnimationStuff.swift
//  Scene sks test
//
//  Created by Michael Jones on 24/02/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit

class AnimationStuff {
    
    // Efficiency: actions are immutable objects, create once, run many times and share across sprites.
    private let myExplodeTextures: Array<SKTexture> = []
    private let myAnimateAction: SKAction
    private let myWaitAction = SKAction.waitForDuration(1)
    private let myFadeAction = SKAction.fadeOutWithDuration(0.5)
        
    init(explodeTextures: Array<SKTexture>) {
        myExplodeTextures = explodeTextures
        myAnimateAction = SKAction.animateWithTextures(myExplodeTextures, timePerFrame: 0.2)
    }
    
    func ExplodeAndRemoveSprite(deadSprite: SKSpriteNode) {
        deadSprite.runAction(SKAction.sequence([myAnimateAction, myWaitAction, myFadeAction, SKAction.removeFromParent()]))
    }    
    
    func ExplodeAndRemoveSprite(deadSprite: SKSpriteNode, callback: (SKSpriteNode)->Void) {
        deadSprite.runAction(SKAction.sequence([myAnimateAction, myWaitAction, myFadeAction, SKAction.removeFromParent()]), completion: {callback(deadSprite)})
    }
}
