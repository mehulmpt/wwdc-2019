/*:

## What is a Solar System?

It is a gravitationally bound planetary system including a Sun (star) and planets that orbit it. Let us construct a very basic solar system on this page

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
//#-code-completion(identifier, show, mercury, venus, earth, mars, jupiter, saturn, uranus, neptune)
let myStar = sun
let myPlanet = /*#-editable-code*/earth/*#-end-editable-code*/
//#-code-completion(identifier, hide, mercury, venus, earth, mars, jupiter, saturn, uranus, neptune)
//#-code-completion(literal, show, boolean)
let originalScale = /*#-editable-code*/false/*#-end-editable-code*/
/*:
**Goal:** Creating a basic star-planet system

1. Firstly, choose a planet you want to add to your sun using the code above
2. We've already selected sun for you, so it will be available for you to add in the live view.
3. Run the code on right and go into full screen
4. Locate a horizontal flat surface (like you did earlier)
5. Place your star *first* and planet *next* and then take a closer look at it!

Let's go!
*/
//#-hidden-code
import PlaygroundSupport
let SolarSystem = ViewController()
SolarSystem.makeOnlyAvailable(name: myPlanet)
SolarSystem.setOriginalScale(originalScale)
PlaygroundPage.current.liveView = SolarSystem
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code