/*:

**Heavenly Body:** It could be used to refer to a star, planet, a moon, comet, etc.

## Stars
Everyone knows about the sun! Sun is actually a star. It is a part of another giant structure called Solar System, which consists of star and planets.

## Planets
Planets are those heavenly bodies which usually orbit around stars. For example, Earth is a planet, and so is Mars.
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
//#-code-completion(identifier, show, sun, jupiter, earth, saturn, mercurcy, venus, mars, uranus, neptune)
let body = /*#-editable-code*/<#body name#>/*#-end-editable-code*/
/*:
**Goal:** Adding first heavenly body

1. Firstly, select a heavenly body you want to add by adding its name in the code above.
2. When you click on the placeholder, you'll see available options (sun, jupiter, earth, saturn, mercury, venus, mars, uranus, neptune)
3. Make your selection
4. Run the code on right and go into full screen 
5. Locate a horizontal flat surface as you did on the previous page
6. Place your body and take a closer look at it!

Let's go!
*/
//#-hidden-code
import PlaygroundSupport
let SolarSystem = ViewController()
SolarSystem.makeOnlyAvailable(name: body)
PlaygroundPage.current.liveView = SolarSystem
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code