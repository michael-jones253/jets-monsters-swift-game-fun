//
//  Speedometer.swift
//  HelloMonstersAndJets
//
//  Created by Michael Jones on 13/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit

public class Speedometer {
    private var myNeedle: SKSpriteNode
    private var mySpeed: CGFloat = 0.0
    private var myMaxSpeed: CGFloat
    
    public init(needle: SKSpriteNode, maxSpeed: CGFloat) {
        myNeedle = needle
        myNeedle.anchorPoint.x = 1
        myMaxSpeed = maxSpeed
    }
    
    public var Colour: SKColor {
        get {
            return myNeedle.color
        }
        
        set(colour) {
            myNeedle.color = colour
        }
    }
    
    public func Update(speed: CGFloat) {
        // FIX ME weighting as init parameters and configurable.
        // A greater percentage for speed rise than fall probably looks best.
        mySpeed = GetSmoothedUpdate(accumulated: mySpeed, update: speed, percentageWeightRise: 20, percentageWeightFall: 10)
        
        var radians = speed / myMaxSpeed * CGFloat(M_PI)
        if (radians > CGFloat(M_PI)) {
            myNeedle.color = SKColor.redColor()
            radians = CGFloat(M_PI)
        }
        else {
            myNeedle.color = SKColor.blueColor()
        }
        
        // Negate to rotate clockwise.
        myNeedle.zRotation = -radians
    }
}
