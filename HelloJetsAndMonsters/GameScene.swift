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
    let myLabel: SKLabelNode
    
    required init?(coder aDecoder: NSCoder) {
        myLabel = SKLabelNode(fontNamed:"Chalkduster")
        super.init(coder: aDecoder)
        
        // MJ moved this from didMoveToView. NB Swift allows constant members to be manipulated
        // in the constructors.
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.addChild(myLabel)
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
        
        // MJ added this.
        let myscene = MyLevel2Scene.UnarchiveSKSceneFromFile("MyLevel2Scene") as? MyLevel2Scene
        myLabel.FadeNodeAwayToScene(myscene!, view: self.view!)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
