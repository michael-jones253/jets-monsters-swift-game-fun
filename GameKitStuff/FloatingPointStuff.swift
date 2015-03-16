//
//  FloatingPointStuff.swift
//  HelloMonstersAndJets
//
//  Created by Michael Jones on 11/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit

public func DifferentByPercentOrMore(num1: CGFloat, num2: CGFloat, percentage: Int)->Bool {
    let percentageNum1 = fabs(num1) * CGFloat(percentage) / 100
    
    let difference = fabs(num1 - num2)
    
    return difference > percentageNum1
}

public func GetSmoothedUpdate(accumulated: CGFloat, update: CGFloat)->CGFloat {
    return accumulated * 0.5 + update * 0.5
}

public func GetSmoothedUpdate(#accumulated: CGFloat, #update: CGFloat, #percentageWeightRise: Int, #percentageWeightFall: Int)->CGFloat {
    var updateWeighting = CGFloat(percentageWeightRise)
    if update < accumulated {
        updateWeighting = CGFloat(percentageWeightFall)
    }
    
    var speed = accumulated * CGFloat(100 - updateWeighting) / 100
    speed += update * updateWeighting / 100
    
    return speed
}
