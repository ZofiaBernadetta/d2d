# d2dApp 

###  Building instructions

- open `d2d.xcodeproj` in Xcode and run the project on an iOS Target.

###  Decisions

- I decided to use Starscream library for dealing with web sockets. I added it to the project as a Swift Package.
- The applicaiton is implemeted with a reactive approach (however, i am not using any reactive framework for it).
- All events published by the web socket endpoint are decoded into an object of a single type (the `Event` struct).
- The endpoint url has been pulled out into a sperate json file, which helps with replacing out configurations for various builds e.g. a relese build and testing build.
