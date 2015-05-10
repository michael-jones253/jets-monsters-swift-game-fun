# jets-monsters-swift-game-fun
OS X SpriteKit game in the swift programming language. My first attempt at writing a game involving collision detection physics and missile firing vector logic. Also my introduction to the Swift programming language which is an alternative to Objective-C for OS X and IOs programming. This game is for the OS X platform.

## My intial reaction to the Swift programming language.
Coming from a C++/C background Swift seems a much more palatable syntax to Objective-C. However, no exceptions? The optional or nullable value somewhat salvages the situation, so instead of throwing an exception let the function return nil for the object.

## Motivation for writing this game.
I was applying for a C++ game job and it was suggested by the prospective employer that I try a home game project. Xcode and SpriteKit is free and quick to learn compared to Unity. Plus I got to learn Swift. I wasn't trying to produce a commercially appealing game, just learn game concepts. However, I did try and use some best practises and scalability:

Avoiding hard coding the physics bodies in the scene. The separation of coding from game layout design is achieved with a) the visual scene design tool which allows a the scene designer to layout the objects visually. b) Loading of other objects through configuration files (.plist in this case). c) Configurable rather than hard coded physics properties.
