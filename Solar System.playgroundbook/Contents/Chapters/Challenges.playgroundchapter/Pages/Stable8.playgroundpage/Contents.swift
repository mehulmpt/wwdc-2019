/*:

## Ultimate power
The time has come! You have the ultimate power of the universe. Reconstruct our real solar system with all 8 planets!

Just for a hint, here's the solar system order starting from the centermost heavenly body to outermost:
1. Sun
2. Mercury
3. Venus
4. Earth
5. Mars
6. Jupiter
7. Saturn
8. Uranus
9. Neptune
*/
//#-hidden-code
var sun = "sun"
var mercury = "mercury"
var venus = "venus"
var earth = "earth"
var mars = "mars"
var jupiter = "jupiter"
var saturn = "saturn"
var uranus = "uranus"
var neptune = "neptune"
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, hide)
let myPlanets = [mercury, venus, earth, mars, jupiter, saturn, uranus, neptune]
//#-code-completion(literal, show, boolean)
let originalScale = /*#-editable-code*/false/*#-end-editable-code*/
//#-hidden-code
/*
**Goal:** Creating a stable 8 planet solar system
 
Your task now is to create a stable 8 based solar system (our home). Our solar system should be stable for at least 15 units of time.

1. Create a solar system normally.
2. Once you're done, press the "Test" button on the screen
3. We'll determine if your solar system is stable by speeding up their revolution (so you don't have to wait for years) speeds of planets and checking if they collide or not

Let's go!
*/
import PlaygroundSupport

let SolarSystem = StableXViewController()
SolarSystem.makeOnlyAvailable(planets: myPlanets)
SolarSystem.setOriginalScale(originalScale)
PlaygroundPage.current.liveView = SolarSystem
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code