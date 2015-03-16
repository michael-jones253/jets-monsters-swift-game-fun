//
//  JetSprite.swift
//  Scene sks test
//
//  Created by Michael Jones on 5/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit
import GameKitStuff

class JetSprite: SKSpriteNode {
    private let myDescription: String
    private let myRedlineSpeed: Int
    private let myMissileLifetimeAction: SKAction
    private let myPercentageBallast: Int
    private let myPercentageAngularDampening: Int
    private var myThrustMagnitude: CGFloat
    private var myAngularThrustMagnitude: CGFloat
    private var myIsThrustOn: Bool = false
    private var myIsLiftOn: Bool = false
    private var myDirtyFlag: Bool = false
    private var mySpeedAtLastDashboardPoll: CGFloat = 0.0
    
    var IsThrustOn: Bool {
        get {
            return physicsBody != nil && myIsThrustOn
        }
        
        set(isOn) {
            if physicsBody != nil {
                myDirtyFlag = true
                myIsThrustOn = isOn
            }
        }
    }
    
    var IsLiftOn: Bool {
        get {
            return physicsBody != nil && myIsLiftOn
        }
        
        set(isOn) {
            if physicsBody != nil {
                myDirtyFlag = true
                myIsLiftOn = isOn
            }
        }
    }
    
    var Description: String {
        get {
            return myDescription
        }
    }
    
    var RedlineSpeed: Int {
        get {
            return myRedlineSpeed
        }
    }
    
    var PercentageAngularDampening: Int {
        get {
            return myPercentageAngularDampening
        }
    }
    
    var PercentageBallast: Int {
        get {
            return myPercentageBallast
        }
    }
    
    init(spriteTexture: SKTexture, spriteColour: SKColor, spriteSize: CGSize, description: String, redlineSpeed: Int, thrustMagnitude: CGFloat, angularThrustMagnitude: CGFloat, percentageBallast: Int, percentageAngularDampening: Int, missileLifetime: NSTimeInterval) {
        
        let lifetime = SKAction.waitForDuration(missileLifetime)
        let expire = SKAction.removeFromParent()
        myMissileLifetimeAction = SKAction.sequence([lifetime, expire])
        
        myDescription = description
        myRedlineSpeed = redlineSpeed
        myThrustMagnitude = thrustMagnitude
        myAngularThrustMagnitude = angularThrustMagnitude
        myPercentageBallast = percentageBallast
        myPercentageAngularDampening = percentageAngularDampening
        
        super.init(texture: spriteTexture, color: spriteColour, size: spriteSize)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ApplyBallast() {
        let multiplier: CGFloat = CGFloat(myPercentageBallast) / 100 + 1
        self.physicsBody?.mass *= multiplier
    }

    func ApplyAngularDampening() {
        let multiplier: CGFloat = CGFloat(myPercentageAngularDampening) / 100 + 1
        self.physicsBody?.angularDamping *= multiplier
    }
    
    func FireMissile(#theScene: SKScene, missileTexture: SKTexture) {
        CreateAndLaunchMissile(theScene: theScene, missileTexture: missileTexture, nodeCategory: MyCollisionMasks.MissileMask, contactNotificationMask: MyCollisionMasks.MonsterMask, magnitude: myThrustMagnitude, lifetimeAction: myMissileLifetimeAction)
    }
    
    func ApplyJetLiftImpulse() {
        ApplyLiftImpulseToZRotation(self, myThrustMagnitude)
    }
    
    func ApplyJetReverseImpulse() {
        ApplyReverseImpulse(myThrustMagnitude)
    }
    
    func ApplyJetAngularImpulse() {
        self.physicsBody?.applyAngularImpulse(myAngularThrustMagnitude)
    }

    func ApplyJetReverseAngularImpulse() {
        self.physicsBody?.applyAngularImpulse(-myAngularThrustMagnitude)
    }
    
    func ApplyJetLiftForce() {
        self.ApplyLiftForce(myThrustMagnitude)
    }
    
    func ApplyJetThrust() {
        self.ApplyThrust(myThrustMagnitude)
    }
    
    func ApplyJetThrustLevel() {
        if myIsThrustOn {
            self.ApplyJetThrust()
        }
    }
    
    func ApplyJetLiftLevel() {
        if myIsLiftOn {
            self.ApplyJetLiftForce()
        }
    }
    
    // Interface implementation.
    func DashboardPoll(dashboard: Dashboard, currentTime: NSTimeInterval) {
        let data = PollForData()
        
        if data != nil {
            dashboard.Update(data!, currentTime: currentTime)
        }
    }
    
    
    func PollForData()->JetDashboardData? {
        if self.physicsBody == nil {
            return nil
        }
        
        let speed = GetMagnitudeFromVector(self.physicsBody!.velocity)
        if (DifferentByPercentOrMore(mySpeedAtLastDashboardPoll, speed, 10)) {
            myDirtyFlag = true
            mySpeedAtLastDashboardPoll = speed
        }

        if (!myDirtyFlag) {
            return nil
        }
                
        var thrustText: String = ""
        if self.myIsThrustOn {
            thrustText = ", Thrust: \(self.myThrustMagnitude)"
        }
        
        if self.myIsLiftOn {
            thrustText = ", Lift: \(self.myThrustMagnitude)"
        }

        let dashboardText: String = "Speed: \(speed)" + thrustText
        myDirtyFlag = false
        
        var dashboardData = JetDashboardData()

        if (myIsLiftOn) {
            dashboardData.Lift = self.myThrustMagnitude
        }
        
        if (myIsThrustOn) {
            dashboardData.Thrust = self.myThrustMagnitude
        }
        
        dashboardData.Speed = mySpeedAtLastDashboardPoll
        
        return dashboardData
    }
    
}