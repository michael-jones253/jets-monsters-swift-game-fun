//
//  MonsterTextures
//  Scene sks test
//
//  Created by Michael Jones on 24/02/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Foundation
import SpriteKit

class MonsterTextures {
    private var myExplodeTextures: Array<SKTexture> = []
    private let myMonsterAtlas = SKTextureAtlas(named: "monster.atlas")    
    
    var ExplodeTextures: Array<SKTexture> {
        get {
            return myExplodeTextures
        }
    }
    
    init() {
        var monsterExplodeTextures = Array<SKTexture>()
        monsterExplodeTextures.append(myMonsterAtlas.textureNamed("monsterExplode1"))
        monsterExplodeTextures.append(myMonsterAtlas.textureNamed("monsterExplode2"))
        monsterExplodeTextures.append(myMonsterAtlas.textureNamed("monsterExplode3"))
        monsterExplodeTextures.append(myMonsterAtlas.textureNamed("monsterExplode4"))
        monsterExplodeTextures.append(myMonsterAtlas.textureNamed("monsterExplode5"))
        monsterExplodeTextures.append(myMonsterAtlas.textureNamed("monsterExplode6"))
        
        myExplodeTextures = monsterExplodeTextures
    }
}