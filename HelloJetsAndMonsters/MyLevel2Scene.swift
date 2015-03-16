//
//  MyLevel2Scene.swift
//  Scene sks test
//
//  Created by Michael Jones on 25/02/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit
import GameKitStuff

class MyLevel2Scene : SKScene, SKPhysicsContactDelegate {

    struct Level {
        static var theLevel:Int = 0
    }
    
    private let mySceneLevelConfiguration: FileLevelLookup
    private let myMonsterLevelConfiguration: FileLevelLookup
    private let myThrustDataLookup: ThrustDataLookup
    private let myMonsters = Array<SKSpriteNode>()
    private let myMissileTexture: SKTexture
    private let myMonsterExplodeTextures: MonsterTextures
    private let myMonsterAnimationStuff: AnimationStuff
    private var myJets = Array<SKSpriteNode>()
    private var myCurrentJet: JetSprite?
    private var myNoticeLabel: SKLabelNode
    private var myStatusLabel: SKLabelNode
    private var myDescriptionLabel: SKLabelNode
    private var myDashboard: Level2Dashboard?
    
    required init?(coder aDecoder: NSCoder) {
        let jetTexture = SKTexture(imageNamed: "Jet")
        let monsterTexture = SKTexture(imageNamed: "Monster")
        
        mySceneLevelConfiguration = FileLevelLookup(plistName: "MySceneFileLevelLookup.plist")
        myMonsterLevelConfiguration = FileLevelLookup(plistName: "MyMonsterFileLevelLookup.plist")
        myThrustDataLookup = ThrustDataLookup(plistName: "ThrustDataLookup.plist")
        myMissileTexture = SKTexture(imageNamed: "Projectile")
        myMonsterExplodeTextures = MonsterTextures()
        myMonsterAnimationStuff = AnimationStuff(explodeTextures: myMonsterExplodeTextures.ExplodeTextures)

        myCurrentJet = nil
        myNoticeLabel = SKLabelNode(fontNamed: "Chalkduster")
        myNoticeLabel.text = "Hello, World!"
        myNoticeLabel.fontSize = 65
        
        // Node is completely transparent.
        myNoticeLabel.alpha = 0
        
        myStatusLabel = SKLabelNode(fontNamed: "Chalkduster")
        myStatusLabel.text = ""
        myStatusLabel.fontSize = 25
        myStatusLabel.fontColor = NSColor.redColor()
        myStatusLabel.alpha = 1.0
        
        myDescriptionLabel = SKLabelNode(fontNamed: "Chalkduster")
        myDescriptionLabel.fontColor = NSColor.redColor()
        myDescriptionLabel.alpha = 1.0

        
        myDashboard = nil
        
        super.init(coder: aDecoder)

        var monsterConfigurationFile = myMonsterLevelConfiguration[Level.theLevel]
        if monsterConfigurationFile == nil {
            // Load default.
            monsterConfigurationFile = "Monster.plist"
        }
        
        myMonsters = CreateSpritesFromScaleAndPositionPlist(plistName: monsterConfigurationFile!, spriteTexture: monsterTexture)
        
        for monster in myMonsters {
            monster.name = "monster"
            self.addChild(monster)
        }

        self.enumerateChildNodesWithName("jet[0-9]", usingBlock: {
            sceneNode, stop in
            let sceneSprite = sceneNode as SKSpriteNode
            
            // Get the thrust data for this particular type of jet (identified by suffix number).
            let jetIdentifiers = sceneSprite.name?.componentsSeparatedByString("jet")
            let jetType = String.toInt(jetIdentifiers![1])
            let j:Int? = jetType()
            
            let thrustData = self.myThrustDataLookup[j!]

            let jet = JetSprite(spriteTexture: jetTexture, spriteColour: sceneSprite.color, spriteSize: sceneSprite.size, description: thrustData.description, redlineSpeed: thrustData.redlineSpeed, thrustMagnitude: thrustData.thrustMagnitude, angularThrustMagnitude: thrustData.angularThrustMagnitude, percentageBallast: thrustData.percentageBallast, percentageAngularDampening: thrustData.percentageAngularDampening, missileLifetime: thrustData.missileLifetime)
            
            // Replace the designer node with the jet sprite we created.
            jet.size = sceneSprite.size
            jet.position = sceneNode.position
            jet.name = "jet"
            
            sceneSprite.removeFromParent()
            self.myJets.append(jet)
            self.addChild(jet)
        })
    }
    
    override func didMoveToView(view: SKView) {
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        self.enumerateChildNodesWithName("jet", usingBlock: {
            jetNode, stop in
            let missileHeight = jetNode.frame.height
            let spacePosition = CGPoint(x:jetNode.position.x - 30, y:jetNode.frame.height * 2);
            jetNode.runAction(SKAction.moveTo(spacePosition, duration: 1.0))

            let jetSprite = jetNode as SKSpriteNode
        })
        
        self.enumerateChildNodesWithName("monster", usingBlock: {
            monsterNode, stop in
            let monsterSprite = monsterNode as SKSpriteNode
            
            // Dynamic of false means that the monsters do not react to scene physics, therefore all movement
            // must be directly manipulated with move and animation actions.
            // However collisions are still detected.
            SetupNodePhysics(monsterSprite, isDynamic: false, nodeCategory: MyCollisionMasks.MonsterMask, contactNotificationMask: MyCollisionMasks.MissileMask)
            
            let lowerLimit = monsterSprite.userData?["LowerTime"] as NSNumber?
            let upperLimit = monsterSprite.userData?["UpperTime"] as NSNumber?
            
            var lowerTime = CGFloat(4.0)
            var upperTime = CGFloat(8.0)
            
            if lowerLimit != nil {
                lowerTime = CGFloat(lowerLimit!)
            }
            
            if upperLimit != nil {
                upperTime = CGFloat(upperLimit!)
            }
            
            RunSpriteForeverInBox(2.0, monsterSprite, self.size, lowerTime: lowerTime, upperTime: upperTime)
        })
        
        myNoticeLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myNoticeLabel)
        
        myStatusLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myStatusLabel)
        
        myDescriptionLabel.position = CGPointMake(myStatusLabel.position.x, myStatusLabel.position.y + myDescriptionLabel.frame.height)
        self.addChild(myDescriptionLabel)
    }

    private func AddCurrentDashboard(jet: JetSprite) {
        var needle = self.childNodeWithName("Needle")
        var speedometerNeedle = needle as SKSpriteNode?
        
        // This throws away the old dashboard. Making new objects is more robust than re-initialising them
        // and good for situations where making the new object is not expensive.
        myDashboard = Level2Dashboard(speedometerNeedle: speedometerNeedle, maxSpeed: CGFloat(jet.RedlineSpeed))

        myDashboard!.Position = CGPoint(x: CGRectGetMinX(self.frame) + myDashboard!.Root.frame.width, y: CGRectGetMidY(self.frame) + myDashboard!.Root.frame.height)
        
        self.addChild(myDashboard!.Root)
    }
    
    private func ResetNeedle() {
        var needle = self.childNodeWithName("Needle")
        var speedometerNeedle = needle as SKSpriteNode?
        speedometerNeedle?.zRotation = 0.0
    }
    
    override func keyDown(theEvent: NSEvent) {
        let chars = theEvent.characters
        
        for char in chars! {
            
            switch char {
            case "L":
                RunNextJet()
                
            case "r":
                myCurrentJet?.ApplyJetReverseImpulse()
                
            case "l":
                // For a continous force effect.
                myCurrentJet?.IsLiftOn = true
                
            case "t":
                // For a continuous force effect.
                myCurrentJet?.IsThrustOn = true
                
            case "f":
                myCurrentJet?.FireMissile(theScene: self, missileTexture: myMissileTexture)

            case "c":
                myCurrentJet?.ApplyJetAngularImpulse()

            case "d":
                let jet = self.myJets.last
                myCurrentJet?.ApplyJetReverseAngularImpulse()
                                
            default:
                break
            }
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        let chars = theEvent.characters
        
        for char in chars! {
            switch char {
            case "l":
                myCurrentJet?.IsLiftOn = false
                
            case "t":
                myCurrentJet?.IsThrustOn = false
                
            default:
                break
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        var keepCurrentJet = false
        
        // Loop through all physics bodies that are in the bounds of the scene.
        self.physicsWorld.enumerateBodiesInRect(self.frame, usingBlock: {
            body, stop in
            if body.node == nil {
                return
            }
            
            // See if the physics body is our current jet.
            let spriteNode = body.node as? SKSpriteNode
            if (spriteNode?.name == "jet") {
                keepCurrentJet = true
            }
       })
        
        // If current jet was not in the scene then consider it lost from this game.
        if (myCurrentJet != nil) {
            if !keepCurrentJet {
                myCurrentJet?.removeFromParent()
                myCurrentJet = nil
                ClearJetInformation()
                myDashboard?.Summary(currentTime)
                
                if myJets.count == 0 {
                    myNoticeLabel.FadeNodeInToScene("You lost :[")
                }
                else {
                    myNoticeLabel.FadeNodeInAndOutOfScene("Sprite is lost in space!")
                }
            }
        }

        // Thrust and lift is applied with a "force" which is based on the time of call and next frame update.
        // So the force method calls need to be called every frame update for a continuous force effect.
        myCurrentJet?.ApplyJetThrustLevel()
        myCurrentJet?.ApplyJetLiftLevel()
        myCurrentJet?.DashboardPoll(myDashboard!, currentTime: currentTime)
        
        // For smoothing reasons this is called on every frame update regardless of whether there has been
        // a speed change or not.
        myDashboard?.UpdateSpeedometer()
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        var missileNode:SKSpriteNode?
        var spaceNode:SKSpriteNode?
        var monsterNode:SKSpriteNode?
        
        // Get any monsters and missiles involved in this collision.
        var monsters = GetCollisionSpritesByCategory(contact, MyCollisionMasks.MonsterMask)
        var missiles = GetCollisionSpritesByCategory(contact, MyCollisionMasks.MissileMask)
        
        // Callback for monster explode animation completion.
        func monsterGone(monster: SKSpriteNode) {
            println("Monster Gone: \(monster.name)")
            
            let anyMonster = self.childNodeWithName("monster")
            if (anyMonster == nil) {
                // No more monsters proceed to next level.
                Level.theLevel++
                
                let nextSceneFileName = mySceneLevelConfiguration[Level.theLevel]
                
                if (nextSceneFileName == nil) {
                    myNoticeLabel.FadeNodeInToScene("You won :]")
                }
                else {
                    let myscene = MyLevel2Scene.UnarchiveSKSceneFromFile(nextSceneFileName!) as? MyLevel2Scene
                    myNoticeLabel.FadeNodeInAndAwayToScene(myscene!, view: self.view!, text: "Final Level")
                }
            }
        }
        
        // If there was a monster AND a missile involved, then explode, remove monster and invoke callback.
        for monster in monsters {
            if missiles.count > 0 {
                monster.removeAllActions()
                myMonsterAnimationStuff.ExplodeAndRemoveSprite(monster, monsterGone)
                
                // TO DO: animate missile destruction.
                missiles[0].removeFromParent()
            }
        }
        
    }

    private func RunNextJet() {
        if (myCurrentJet != nil) {
            // Still got a current jet.
            return
        }
    
        if self.myJets.count == 0 {
            // No more jets to run.
            return
        }
        
        let nextJet = self.myJets.last as? JetSprite
        self.myJets.removeLast()
        
        UpdateJetInformationOnLaunchRequest(nextJet!)
        
        // This is a called only once jet is airborne with non-physics actions run.
        func ApplyLiftImpulseCallback(sprite: SKSpriteNode) {
            nextJet?.removeAllActions()

            SetupNodePhysics(nextJet!, isDynamic: true, nodeCategory: MyCollisionMasks.JetMask, contactNotificationMask: MyCollisionMasks.SpaceshipMask)
            nextJet?.ApplyBallast()
            nextJet?.ApplyAngularDampening()
            nextJet?.ApplyJetLiftImpulse()
            
            // All move actions gone, OK for controls to operate on jet now.
            myCurrentJet = nextJet
            
            UpdateJetInformationOnLiftOff()
        }
        
        
        RunSpriteXWithCallback(nextJet!, self.size, ApplyLiftImpulseCallback)
    }
    
    private func UpdateJetInformationOnLaunchRequest(jet: JetSprite) {
        // Remove old dashboard.
        myDashboard?.Root.removeFromParent()
        ResetNeedle()
        
        DisplayJetDescription(jet.Description)
    }
    
    private func UpdateJetInformationOnLiftOff() {
        
        if (myCurrentJet == nil) {
            myStatusLabel.text = ""
            println("Error: shouldn't happen - null jet on lift off")
            return
        }

        AddCurrentDashboard(myCurrentJet!)
        
        let details:String = "Ballast: \(myCurrentJet!.PercentageBallast), Dampening: \(myCurrentJet!.PercentageAngularDampening)"
        myStatusLabel.text = details

        myDescriptionLabel.text = ""
    }
    
    private func DisplayJetDescription(description: String) {
        myDescriptionLabel.text = description
    }
    
    private func ClearJetInformation() {
        myStatusLabel.text = ""
    }
    
}
