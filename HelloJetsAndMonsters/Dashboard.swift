//
//  Dashboard.swift
//  HelloMonstersAndJets
//
//  Created by Michael Jones on 11/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit

// Reduce coupling between JetSprite and actual dashboard implementation, thus allowing scenes to define
// their own dashboard variations. Reducing coupling also helps with unit testing of individual components.
protocol Dashboard {
    func Update(data: JetDashboardData, currentTime: NSTimeInterval)
}
