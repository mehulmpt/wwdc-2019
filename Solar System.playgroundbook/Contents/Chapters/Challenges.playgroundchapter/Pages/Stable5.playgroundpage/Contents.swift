/*:

## Stable 5

Things are getting serious! Let us now take a look at a system with 5 planets, but this time, you HAVE to use the original scale of planets. Find a bigger planar place and get going!
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
let myPlanets = [
    /*#-editable-code*/<#Planet 1#>/*#-end-editable-code*/,
    /*#-editable-code*/<#Planet 2#>/*#-end-editable-code*/,
    /*#-editable-code*/<#Planet 3#>/*#-end-editable-code*/,
    /*#-editable-code*/<#Planet 4#>/*#-end-editable-code*/,
    /*#-editable-code*/<#Planet 5#>/*#-end-editable-code*/
]
//#-code-completion(identifier, hide, mercury, venus, earth, mars, jupiter, saturn, uranus, neptune)
//#-code-completion(literal, show, boolean)
let originalScale = true // big planets ;)
/*:
**Goal:** Creating a stable 5 planet solar system

1. Select 5 planets of your choice from above (use suggestions provided)
2. Create a solar system normally.
3. Once you're done, press the "Test" button on the screen
4. We'll determine if your solar system is valid by randomizing speeds of planets and checking if they collide or not

Let's go!
*/
//#-hidden-code
import PlaygroundSupport

let SolarSystem = StableXViewController()
SolarSystem.makeOnlyAvailable(planets: myPlanets)
SolarSystem.setOriginalScale(originalScale)
PlaygroundPage.current.liveView = SolarSystem
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code