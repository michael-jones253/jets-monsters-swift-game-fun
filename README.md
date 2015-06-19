# jets-monsters-swift-game-fun
OS X SpriteKit game in the swift programming language. My first attempt at writing a game involving collision detection physics and missile firing vector logic. Also my introduction to the Swift programming language which is an alternative to Objective-C for OS X and IOs programming. This game is for the OS X platform.

## My intial reaction to the Swift programming language.
Coming from a C++/C background Swift seems a much more palatable syntax to Objective-C. However, no exceptions? The optional or nullable value somewhat salvages the situation, so instead of throwing an exception let the function return nil for the object.

## Motivation for writing this game.
I was applying for a C++ game job at a future start-up and it was suggested by the prospective employer that I try a home game project. Xcode and SpriteKit is free and quick to learn compared to Unity. Plus I got to learn Swift. I wasn't trying to produce a commercially appealing game, just learn game concepts. However, I did try and use some best practises and scalability.

The employer seemed happy with what I had done when I demonstrated it and gave a brief walk-through, however the start up wasn't ready to start up.

## Some best practises and scalability used.

Avoiding hard coding the physics bodies in the scene. The separation of coding from game layout design is achieved with a) the visual scene design tool which allows a the scene designer to layout the objects visually. b) Loading of other objects through configuration files (.plist in this case). c) Configurable rather than hard coded physics properties.

## What the game does and what emerged from the learning experience.

This game grew from a hello world style project, the initial wizard setup and limited graphics resources that come with Xcode SpriteKit and some tutorials on the web. It is therefore rather baroque to play and involves monsters running randomly around the scene and trying to shoot them down from a fleet of difficult to control vechicles which are a cross between a  Harrier jump jet and a spaceship. If loss of control of the jet causes them to fly out of the scene then they are considered "lost in space". Lose all your jets then game over. Shoot down all the monsters then win.

There are two ways of moving SpriteKit bodies (known as Sprites):
1. Give them a destination coordinate and a time to get there and the game engine animation will calculate and smooth out a speed to achieve this.
2. Apply forces to the physics body.

The SpriteKit physics body is necessary for collision detection in both cases above, however it can either have dynamic or non-dynamic physics attribute. Dynamic means that they respond to gravity, will bounce during collisions, come to a halt/stop rotating due to dampening etc. However, it seems that moving the Sprite using method 1 above is incompatible with dynamic physics on - the Sprite will start vibrating and bouncing around completely erratically.

So this game is based upon monsters that move around randomly using method 1. and dynamic physics off. The jets have dynamic physics on and are moved by using method 2.

Level 2 of this game is exactly the same code as Level 1, however the scene is re-arranged by loading level 2 from different configuration files. The jets also have different dynamic behaviour due to being configured with different amounts of ballast and being given different amounts of thrust and dampening. The point of Level 2 is to demonstrate the ability of the game to load different behaviour from configuration.

To actually get the jets to fly and be reasonably controllable (but not too easy to control) took a bit of messing around with the physics properties. I made all these properties configurable in keeping with best practices.



