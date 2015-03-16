//
//  ScalingStuff.swift
//  Scene sks test
//
//  Created by Michael Jones on 23/02/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit


public func CreateSpritesFromScaleAndPositionPlist(#plistName:String, #spriteTexture:SKTexture) ->Array<SKSpriteNode>{
    var nodes = Array<SKSpriteNode>()
    let dataFile = NSBundle.mainBundle().pathForResource(plistName, ofType: nil)
    let spriteData = NSArray(contentsOfFile: dataFile!)
    
    for i in 0..<spriteData!.count {
        let nodeDictionary = spriteData![i] as NSDictionary
        
        let scale = CGFloat(nodeDictionary["Scale"] as NSNumber)
        let position = NSPointFromString(nodeDictionary["Position"] as String)
        
        let cgPosition = NSPointToCGPoint(position)
        
        let sprite = SKSpriteNode(texture: spriteTexture)
        sprite.position = cgPosition
        sprite.setScale(scale)
        
        sprite.userData = NSMutableDictionary(dictionary: nodeDictionary)

        nodes.append(sprite)
    }
    
    return nodes
}