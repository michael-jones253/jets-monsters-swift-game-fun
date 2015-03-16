//
//  MyTest.swift
//  HelloJetsAndMonsters
//
//  Created by Michael Jones on 16/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation

public class MyTest {
    private let myGreeting: String = "Hello"
    
    public var Greeting: String {
        get {
            return myGreeting
        }
    }
    
    public init() {
        
    }

    public func GoodBye() {
        println("Goodbye cruel world")
    }
    
    public func Greet() {
        println("\(myGreeting)")
    }
}