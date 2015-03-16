//
//  RandomStuff.swift
//  Scene sks test
//
//  Created by Michael Jones on 24/02/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit

public func Random()->CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

public func Random(#min: CGFloat, #max: CGFloat)->CGFloat {
    return Random() * (max - min) + min
}

public func RunSpriteXWithCallback(sprite:SKSpriteNode, box:CGSize, callback: (SKSpriteNode)->Void) {
    let actualDuration = Random(min: CGFloat(2.0), max: CGFloat(4.0))
    // let actualY = random(min: sprite.size.height/2, max: box.height - sprite.size.height/2)
    let actualX = Random(min: sprite.size.width/2, max: box.width - sprite.size.width/2)
    
    let randomMove = SKAction.moveToX(actualX, duration: NSTimeInterval(actualDuration))
    sprite.runAction(randomMove, completion: { callback(sprite) })
}

public func RunSpriteOneMoveInBox(sprite:SKSpriteNode, box:CGSize) {
    let actualDuration = Random(min: CGFloat(2.0), max: CGFloat(4.0))
    let actualY = Random(min: sprite.size.height/2, max: box.height - sprite.size.height/2)
    let actualX = Random(min: sprite.size.width/2, max: box.width - sprite.size.width/2)
    
    let randomMove = SKAction.moveTo(CGPoint(x: actualX, y: actualY), duration: NSTimeInterval(actualDuration))
    
    // I don't think this is recursion.
    sprite.runAction(randomMove)
}

public func RunSpriteTwoMovesInBox(sprite:SKSpriteNode, box:CGSize) {
    let actualDuration = Random(min: CGFloat(2.0), max: CGFloat(4.0))
    let actualY = Random(min: sprite.size.height/2, max: box.height - sprite.size.height/2)
    let actualX = Random(min: sprite.size.width/2, max: box.width - sprite.size.width/2)
    
    let actionMove = SKAction.moveTo(CGPoint(x: sprite.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
    let xMove = SKAction.moveTo(CGPoint(x: actualX, y: actualY), duration: NSTimeInterval(actualDuration))
    
    // I don't think this is recursion.
    sprite.runAction(SKAction.sequence([actionMove, xMove]))
}

public func CreateRandomMoveAction(sprite:SKSpriteNode, box:CGSize, #lowerTime: CGFloat, #upperTime: CGFloat)->SKAction {
    let actualDuration = Random(min: CGFloat(lowerTime), max: CGFloat(upperTime))
    let actualY = Random(min: sprite.size.height/2, max: box.height - sprite.size.height/2)
    let actualX = Random(min: sprite.size.width/2, max: box.width - sprite.size.width/2)
    
    let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: actualY), duration: NSTimeInterval(actualDuration))
    
    return actionMove
}

public func RunSpriteForeverInBox(
        startDelay: NSTimeInterval,
        sprite:SKSpriteNode,
        box:CGSize,
        #lowerTime: CGFloat,
        #upperTime: CGFloat) {
    let waitAction = SKAction.waitForDuration(startDelay)
            
    // We cannot cache this action, because it needs to be generated with a new random time every use.
    let randomMove = CreateRandomMoveAction(sprite, box, lowerTime: lowerTime, upperTime: upperTime)

    // I don't think this is recursion. I think that once the old action is finished then the game update
    // mechanism runs the callback not this routine.
    sprite.runAction(randomMove, completion: {
        sprite.removeAllActions()
        RunSpriteForeverInBox(startDelay, sprite, box, lowerTime: lowerTime, upperTime: upperTime)
        
    })
}