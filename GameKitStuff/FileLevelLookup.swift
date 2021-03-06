//
//  FileLevelLookup.swift
//  HelloMonstersAndJets
//
//  Created by Michael Jones on 9/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation

public class FileLevelLookup {
    private let mySceneLookup: NSArray
    
    public init(plistName: String) {
        let dataFile = NSBundle.mainBundle().pathForResource(plistName, ofType: nil)
        mySceneLookup = NSArray(contentsOfFile: dataFile!)!
    }
    
    public subscript(index: Int) -> String? {
        
        if (index >= mySceneLookup.count) {
            return nil
        }

        let sceneFileName = mySceneLookup[index] as! NSString
        
        return String(sceneFileName)
    }
    
    
    
}