/*:

## Stable 3

Welcome to your first challenge! Here we shall create a solar system consisting of a star and 3 planets of your choice. Your task is to make a stable system. A stable system is a solar system which does not collapse for at least 10 units of time. Are you ready?
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
    /*#-editable-code*/<#Planet 3#>/*#-end-editable-code*/
]
//#-code-completion(identifier, hide, mercury, venus, earth, mars, jupiter, saturn, uranus, neptune)
//#-code-completion(literal, show, boolean)
let originalScale = /*#-editable-code*/true/*#-end-editable-code*/
/*:
**Goal:** Creating a stable 3 planet solar system

1. Select 3 planets of your choice from above (use suggestions provided)
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