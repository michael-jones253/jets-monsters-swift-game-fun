//
//  ThrustDataLookup.swift
//  Scene sks test
//
//  Created by Michael Jones on 8/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation


class ThrustDataLookup {
    private let myJetDataLookup: NSArray
    
    init(plistName: String) {
        let dataFile = NSBundle.mainBundle().pathForResource(plistName, ofType: nil)
        myJetDataLookup = NSArray(contentsOfFile: dataFile!)!
    }
    
    subscript(index: Int) -> (description:String, redlineSpeed:Int, thrustMagnitude: CGFloat, angularThrustMagnitude: CGFloat, missileLifetime: NSTimeInterval, percentageBallast: Int, percentageAngularDampening: Int) {
        
        let jetData = myJetDataLookup[index] as NSDictionary
        let description = String(jetData["Description"] as NSString)
        let redlineSpeed = Int(jetData["RedlineSpeed"] as NSNumber)
        let jetThrust = CGFloat(jetData["JetThrust"] as NSNumber)
        let jetAngularThrust = CGFloat(jetData["JetAngularThrust"] as NSNumber)
        let missileLifetime = NSTimeInterval(jetData["MissileLifetime"] as NSNumber)
        let percentageBallast = Int(jetData["PercentageBallast"] as NSNumber)
        let percentageAngularDampening = Int(jetData["PercentageAngularDampening"] as NSNumber)
        
        return (description, redlineSpeed, jetThrust, jetAngularThrust, missileLifetime, percentageBallast, percentageAngularDampening)
        
    }
    
}