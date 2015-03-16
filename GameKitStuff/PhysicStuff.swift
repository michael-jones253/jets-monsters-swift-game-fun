//
//  PhysicStuff.swift
//  Scene sks test
//
//  Created by Michael Jones on 23/02/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit

public func GetCollisionSpriteByCategory(collisionBody: SKPhysicsBody, category:UInt32)->SKSpriteNode? {
    if collisionBody.categoryBitMask & category != 0 {
        return collisionBody.node as? SKSpriteNode
    }
    
    return nil
}

public func GetCollisionSpritesByCategory(collisionContact:SKPhysicsContact, category:UInt32) ->Array<SKSpriteNode> {
    var nodes = Array<SKSpriteNode>()
    
    let spriteA = GetCollisionSpriteByCategory(collisionContact.bodyA, category)
    if spriteA != nil {
        nodes.append(spriteA!)
    }
    
    let spriteB = GetCollisionSpriteByCategory(collisionContact.bodyB, category)
    if spriteB != nil {
        nodes.append(spriteB!)
    }
    
    return nodes
}

public func SetupNodePhysics(sprite:SKSpriteNode, #isDynamic:Bool, #nodeCategory:UInt32, #contactNotificationMask:UInt32) {
    sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.frame.size)
    
    // Whether it has in built sprite kit physics or not.
    sprite.physicsBody?.dynamic = isDynamic
    
    // The physics identifier for this node.
    sprite.physicsBody?.categoryBitMask = nodeCategory
    
    // The categories for which contact notifications will be given. May be for multiple categories.
    sprite.physicsBody?.contactTestBitMask = contactNotificationMask
    
    // The categories that this node can collide with (but not necessarily give notifications.
    // Leave as default: all set, so will collide with everything.
    // sprite.physicsBody?.collisionBitMask
}

public func ApplyLiftImpulseToZRotation(sprite: SKSpriteNode, magnitude: CGFloat) {
    let impulseVector = GetVectorFromRotation(sprite, magnitude: magnitude, extraRotation: CGFloat(M_PI_2))
    
    // Assume stationary launch.
    let zeroSpeedVector = CGVectorMake(0, 0)
    sprite.physicsBody?.velocity = zeroSpeedVector
    
    // Applies an immediate burst.
    // We do not have to worry about maintaining a force across frame updates.
    sprite.physicsBody?.applyImpulse(impulseVector)
}

extension SKSpriteNode {
    public func ApplyLiftForce(magnitude: CGFloat) {
        let forceVector = GetVectorFromRotation(self, magnitude: magnitude, extraRotation: CGFloat(M_PI_2))

        self.physicsBody?.applyForce(forceVector)
    }

    public func ApplyThrust(magnitude: CGFloat) {
        let forceVector = GetVectorFromRotation(self, magnitude: magnitude, extraRotation: CGFloat(0.0))
        
        self.physicsBody?.applyForce(forceVector)
    }
    
    public func ApplyReverseImpulse(magnitude: CGFloat) {
        let impulseVector = GetVectorFromRotation(self, magnitude: magnitude, extraRotation: CGFloat(M_PI))
        
        self.physicsBody?.applyImpulse(impulseVector)
    }
    
    public func CreateAndLaunchMissile(#theScene:SKScene, missileTexture: SKTexture, nodeCategory:UInt32, contactNotificationMask:UInt32,  magnitude: CGFloat, lifetimeAction: SKAction) {
        var missile = SKSpriteNode(texture: missileTexture)
        missile.position = self.position
        theScene.addChild(missile)

        missile.physicsBody = SKPhysicsBody(circleOfRadius: missile.frame.size.width / 2)
        
        // Missile reacts to scene physics.
        missile.physicsBody?.dynamic = true
        
        // First set the missiles velocity to that of this owning sprite, so that the missile carries the
        // momentum of the jet even before the firing impulse is applied.
        missile.physicsBody?.velocity = self.physicsBody!.velocity
        
        missile.physicsBody?.categoryBitMask = nodeCategory
        missile.physicsBody?.contactTestBitMask = contactNotificationMask
        
        // Missiles don't collide with each other in this game.
        missile.physicsBody?.collisionBitMask ^= self.physicsBody!.categoryBitMask
        
        // We get the vector from the owners rotation, not the missile.
        let impulseVector = GetVectorFromRotation(self, magnitude: magnitude, extraRotation: 0.0)
        missile.physicsBody?.applyImpulse(impulseVector)

        // Ensure that we don't keep consuming resources and arrange to remove the missile after a period.
        missile.runAction(lifetimeAction)
    }
}