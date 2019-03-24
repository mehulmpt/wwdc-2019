/*:
# Introduction To This Book
This book is my submission for WWDC Scholarship 2019. It allows you to learn interactively about star-planet systems and construct some of your own too!

## Credits
1. Image Sprites: [FlatIcon](https://www.flaticon.com)
2. 3D Textures: [Solar System Scope Textures](https://solarsystemscope.com/textures/)
3. Sounds: [ZapSplat](https://www.zapsplat.com)
3. And last but not the least, [Apple Documentation](https://developer.apple.com/documentation/)

## Points to consider
1. Please make sure to use Live View in full-screen mode for best experience
2. `let originalScale = true` means that the planets would be rendered proportional to each other close to actual ratios (however, still not exact). Use it if you're testing on a big ARPlane surface (recommended)
3. `let originalScale = false` means that the planets would be rendered almost identical in size. Use if you're testing on a small ARPlane surface.

**That's all for this page. Go to next page when you're ready :)** 
*/
//#-hidden-code
import PlaygroundSupport
PlaygroundPage.current.assessmentStatus = .pass(message: "Next page when you're ready!\(getNextPage())")
//#-end-hidden-code