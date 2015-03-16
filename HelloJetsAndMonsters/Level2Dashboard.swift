//
//  Level2Dashboard.swift
//  HelloMonstersAndJets
//
//  Created by Michael Jones on 12/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit
import GameKitStuff

class Level2Dashboard : Dashboard {
    private var mySpeedometer: Speedometer?
    private var myRoot: SKNode
    private var mySpeedLabel: SKLabelNode
    private var myThrustLabel: SKLabelNode
    private var myLiftLabel: SKLabelNode
    private var mySummaryLine1Label: SKLabelNode
    private var mySummaryLine2Label: SKLabelNode
    private var myMaxSpeed: CGFloat = 0.0
    private var myTimeAtLastUpdate: NSTimeInterval = 0
    private var myFlightStartTime: NSTimeInterval = 0
    private var myDataAtLastUpdate: JetDashboardData = JetDashboardData()
    private var myFuelBurned: Double = 0.0
    
    var Position: CGPoint {
        get {
            return myRoot.position
        }
        
        set(pos) {
            myRoot.position = pos
        }
    }
    
    var Root: SKNode {
        get {
            return myRoot
        }
    }
    
    init(speedometerNeedle: SKSpriteNode?, maxSpeed: CGFloat) {
        if speedometerNeedle != nil {
            mySpeedometer = Speedometer(needle: speedometerNeedle!, maxSpeed: maxSpeed)
        }
        
        mySpeedometer?.Update(0.0)
        
        // Sprite Kit best practises. Organise content nodes into layers (trees) under SKNodes.
        myRoot = SKNode()
        mySpeedLabel = SKLabelNode(fontNamed: "Chalkduster")
        myThrustLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLiftLabel = SKLabelNode(fontNamed: "Chalkduster")
        mySummaryLine1Label = SKLabelNode(fontNamed: "Chalkduster")
        mySummaryLine2Label = SKLabelNode(fontNamed: "Chalkduster")
        
        // Frame size of label not set until some text.
        // There are maybe other ways (try setting fontsize), but this is ok for debugging.
        mySpeedLabel.text = "Speed"
        mySpeedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        myThrustLabel.text = "Thrust"
        myThrustLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        myThrustLabel.position.y = mySpeedLabel.frame.height
        
        myLiftLabel.text = "Lift"
        myLiftLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        myLiftLabel.position.y = mySpeedLabel.frame.height + myLiftLabel.frame.height
        
        mySummaryLine2Label.text = "Summary"
        mySummaryLine2Label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        mySummaryLine2Label.position.y = mySpeedLabel.frame.height + myThrustLabel.frame.height + myLiftLabel.frame.height
        
        mySummaryLine2Label.text = "Summary2"
        mySummaryLine1Label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        mySummaryLine1Label.position.y = mySpeedLabel.frame.height + myThrustLabel.frame.height + myLiftLabel.frame.height + mySummaryLine2Label.frame.height
        
        myRoot.addChild(mySpeedLabel)
        
        myRoot.addChild(myThrustLabel)
        myRoot.addChild(myLiftLabel)
    }
    
    func Update(data: JetDashboardData, currentTime: NSTimeInterval) {
        myLiftLabel.text =  "Lift: \(data.Lift)"
        if (data.Lift > 0) {
            myLiftLabel.fontColor = SKColor.redColor()
        }
        else {
            myLiftLabel.fontColor = SKColor.whiteColor()
        }
        
        myThrustLabel.text = "Thrust: \(data.Thrust)"
        if (data.Thrust > 0) {
            myThrustLabel.fontColor = SKColor.redColor()
        }
        else {
            myThrustLabel.fontColor = SKColor.whiteColor()
        }
        
        mySpeedLabel.text = NSString(format: "Speed: %.2f", Float(data.Speed))
        
        if (data.Speed > myMaxSpeed) {
            myMaxSpeed = data.Speed
        }
        
        UpdateFuelBurned(data, currentTime: currentTime)
        
        myTimeAtLastUpdate = currentTime
        myDataAtLastUpdate = data
    }
    
    // For smoothing reasons this should be called on every frame update regardless of
    // whether there has been a speed change or not.
    func UpdateSpeedometer() {
        mySpeedometer?.Update(myDataAtLastUpdate.Speed)
    }
    
    private func UpdateFuelBurned(data: JetDashboardData, currentTime: NSTimeInterval) {
        if myTimeAtLastUpdate.isZero {
            // First time called, no previous reading.
            myFlightStartTime = currentTime
            return
        }
        
        let duration = currentTime - myTimeAtLastUpdate
        
        myFuelBurned += Double(myDataAtLastUpdate.Lift) * duration
        myFuelBurned += Double(myDataAtLastUpdate.Thrust) * duration
    }
    
    func Summary(currentTime: NSTimeInterval) {
        let flightDuration = Int(currentTime - myFlightStartTime)
        mySummaryLine2Label.fontColor = SKColor.blackColor()
        mySummaryLine2Label.text = String(format: "Maximum speed: %.2f, Fuel burned: %.2f", arguments: [Float(myMaxSpeed), Float(myFuelBurned)])
        
        let minutes = flightDuration / 60
        let seconds = flightDuration % 60
        
        mySummaryLine1Label.fontColor = SKColor.blackColor()
        mySummaryLine1Label.text = "Flight time: \(minutes) minutes \(seconds) seconds"
        
        // Efficiency - remove unwanted nodes rather than just blank out text.
        myRoot.removeAllChildren()
        
        // Efficiency - only add nodes when needed.
        myRoot.addChild(mySummaryLine1Label)
        myRoot.addChild(mySummaryLine2Label)
        
        mySpeedometer?.Colour = SKColor.blackColor()
        
        // No need for further updates on this dashboard.
        mySpeedometer = nil
    }
    
    deinit {
        
    }
}
