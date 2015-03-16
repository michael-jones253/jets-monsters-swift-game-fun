//
//  VectorStuff.swift
//  HelloMonstersAndJets
//
//  Created by Michael Jones on 11/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit

public func GetMagnitudeFromVector(vector: CGVector)->CGFloat {
    return sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
}

public func GetVectorFromRotation(spaceSprite:SKSpriteNode, #magnitude: CGFloat, #extraRotation: CGFloat)->CGVector {
    // zRotation is about Z axis and is 0 from the y axis. Parametric equation is from x axis.
    // So if we want lift instead of forward thrust add 90 degrees of rotation via the adjustment parameter.
    // Rotation can also be more than one rotation so modulus
    // one complete rotation of radians (M_PI * 2).
    let spaceRotation = (spaceSprite.zRotation + CGFloat(extraRotation)) % CGFloat(M_PI * 2)
    
    var rotatedX = magnitude * cos(spaceRotation)
    var rotatedY = magnitude * sin(spaceRotation)
    let fireMove = CGVectorMake(rotatedX, rotatedY)
    
    return fireMove
}
