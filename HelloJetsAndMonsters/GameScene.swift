//
//  GameScene.swift
//  HelloJetsAndMonsters
//
//  Created by Michael Jones on 15/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import SpriteKit
import TestFrameWork
import GameKitStuff


class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        let jetTexture = SKTexture(imageNamed: "Jet")
        
        self.addChild(myLabel)
        
        var node = self.childNodeWithName("Jet")
        
        let jet = SKSpriteNode(texture: jetTexture)
        jet.position = node!.position
        
        self.addChild(jet)

        node?.removeFromParent()
        
        let projectileTexture = SKTexture(imageNamed: "Projectile")
        
        node = self.childNodeWithName("projectile")
        
        let projectile = SKSpriteNode(texture: projectileTexture)
        projectile.position = node!.position
        
        self.addChild(projectile)
        
        node?.removeFromParent()

        let x = MyTest()
        x.GoodBye()
        
        myLabel.text = x.Greeting
        
        let testTextures = Array<SKTexture>()
        
        let testAnimation = AnimationStuff(explodeTextures: testTextures)
        
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        let location = theEvent.locationInNode(self)
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        sprite.position = location;
        sprite.setScale(0.5)
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        sprite.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(sprite)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
