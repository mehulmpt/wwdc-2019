import UIKit
import SceneKit
import ARKit
import PlaygroundSupport

public class StableXViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate, PlaygroundLiveViewSafeAreaContainer {
	var sceneView: ARSCNView!	
	let AssesmentStatus = ASHandler()
	let Solar = HeavenlyBody()
	let testDuration: Double = 10
	var scroller: UIScrollView!
	var background: UIView!
	var text3DNode: SCNNode!
	var testTimer: Timer?
	var useOriginalRadius: Bool! = true
	var finished: Bool! = false
	var planetStack: [UIButton]! = []
	var controlStack: [UIButton]! = []
	var activeButton: UIButton!
	var planes = [ARPlaneAnchor: Plane]()

	var buttonsLeftCount: Int! = 0

	var activePlanets: [String]! = []

	var testInProgress: Bool!

	@objc
	func planetButtonAction(sender: UIButton!) {
		for btn in planetStack {
			btn.alpha = 0.3
		}
		sender.alpha = 1
		activeButton = sender
	}

	public func makeOnlyAvailable(planets: [String]) {
        activePlanets = planets
    }

	public func setOriginalScale(_ val: Bool) {
		useOriginalRadius = val
	}

	func freezeButtons() {
		for btn in planetStack {
			btn.isEnabled = false
		}
		for btn in controlStack {
			btn.isEnabled = false
		}
		testInProgress = true
	}

	func unFreezeButtons() {
		for btn in planetStack {
			btn.isEnabled = true
		}
		for btn in controlStack {
			btn.isEnabled = true
		}
	}

	func unFreezeReset() {
		controlStack[1].isEnabled = true
	}

	func freezeTestButton() {
		controlStack[0].isEnabled = false
	}

	func unFreezeTestButton() {
		controlStack[0].isEnabled = true
	}

	func testComplete(successful: Bool) {

		testTimer?.invalidate()
		testInProgress = false

		if successful {
			if let textNode = text3DNode.childNode(withName: "text", recursively: true) as? SCNNode {
				(textNode.geometry as? SCNText)?.string = "Nice work!"
				let (min, max) = textNode.boundingBox

				let dx = min.x + 0.5 * (max.x - min.x)
				let dy = min.y + 0.5 * (max.y - min.y)
				let dz = min.z + 0.5 * (max.z - min.z)
				textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
			}

			unFreezeButtons()

			let planets: [SCNNode] = Solar.getAllPlanets()

			for planet in planets {
				// remove existing spins
				planet.removeAllActions()
				if let rawPlanet = planet.childNode(withName: "planet", recursively: true) as? SCNNode {
					rawPlanet.childNode(withName: "planet-core", recursively: true)!.removeAllActions()
					Solar.rotateAndRevolvePlanet(system: planet, ring: false, delay: 0)
				}

				if let rawRing = planet.childNode(withName: "planet-ring", recursively: true) as? SCNNode {
					rawRing.childNode(withName: "planet-core", recursively: true)!.removeAllActions()
					Solar.rotateAndRevolvePlanet(system: planet, ring: true, delay: 0)
				}

				// add back test spins
			}

			AssesmentStatus.setPassMessage("**Great job!**\n\nYour proposed system is stable.\n\n[**Next Page**](@next)", keepAlive: true)
			finished = true
		} else {

			if let textNode = text3DNode?.childNode(withName: "text", recursively: true) as? SCNNode {
				(textNode.geometry as? SCNText)?.string = "Possible Collision Detected!"
				let (min, max) = textNode.boundingBox

				let dx = min.x + 0.5 * (max.x - min.x)
				let dy = min.y + 0.5 * (max.y - min.y)
				let dz = min.z + 0.5 * (max.z - min.z)
				textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
			}

			freezeButtons()
			Solar.freezePlanets()
			unFreezeReset()
		}
	}

	func showTestCountdown() {
		var count = 10
		var text = SCNText(string: String(count), extrusionDepth: 0.1)
		text.font = UIFont.systemFont(ofSize: 1.5)
		text.flatness = 0.01
		text.firstMaterial?.diffuse.contents = UIColor.white

		let textNode = SCNNode(geometry: text)
		let fontSize = Float(0.04)
		textNode.scale = SCNVector3(fontSize, fontSize, fontSize)

		let (min, max) = textNode.boundingBox

		let dx = min.x + 0.5 * (max.x - min.x)
		let dy = min.y + 0.5 * (max.y - min.y)
		let dz = min.z + 0.5 * (max.z - min.z)
		textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
		textNode.name = "text"
		
		text3DNode?.removeFromParentNode()
		text3DNode = SCNNode()
		text3DNode.addChildNode(textNode)

		text3DNode.position = Solar.getStarPosition()
		text3DNode.position.y += Float(0.1) + Solar.getStarRadius()

		testTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
			count = count - 1
			text.string = String(format: "%02d", count)
			if count == 0 {
				self?.testComplete(successful: true)
			}
		}

		sceneView.scene.rootNode.addChildNode(text3DNode)
	}

	@objc
	func controlButtonAction(sender: UIButton!) {
		if sender.stringTag() == "Test" {
			// test button

			let planets: [SCNNode] = Solar.getAllPlanets()

			for planet in planets {
				// remove existing spins
				planet.removeAllActions()
				let rawPlanet = planet.childNode(withName: "planet", recursively: true) as? SCNNode
				let rawRing = planet.childNode(withName: "planet-ring", recursively: true) as? SCNNode
				rawPlanet?.childNode(withName: "planet-core", recursively: true)!.removeAllActions()
				//rawPlanet?.runAction(FastRotation(rawPlanet!))
				rawPlanet?.childNode(withName: "planet-core", recursively: true)!.runAction(FastRotation())

				rawRing?.childNode(withName: "planet-core", recursively: true)!.removeAllActions()
				//rawRing?.runAction(FastRevolution(distance: Solar.getOrbitalRadius(planet), mass: Float(planet.physicsBody!.mass)))
				rawRing?.childNode(withName: "planet-core", recursively: true)!.runAction(VerySlowRotation())
				// add test spins
				planet.runAction(FastRevolution(distance: Solar.getOrbitalRadius(planet), mass: Float(planet.physicsBody!.mass)))

				//rings?.runAction(FastRevolution(distance: Solar.getOrbitalRadius(planet), mass: Float(rawPlanet.physicsBody!.mass), reverse: true), forKey: "spin")
			}

			freezeButtons()
			showTestCountdown()

		} else if sender.stringTag() == "Reset" {
			resetScene()
		}
	}

	func resetScene() {
		finished = false
		sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
			if let name = node.name {
				if name == "star-system" || name == "planet-system" {
					node.removeFromParentNode()
				}
			}
		}
		// unFreezeButtons() panel is reconstruced anyway
		text3DNode?.removeFromParentNode()
		Solar.softResetSystem()
		setupViews()
		AssesmentStatus.setStatusToNil()
	}

	func setupViews() {
		testInProgress = false

		let planetTray = ["sun"] + activePlanets
		let controlTray = ["Test", "Reset"]

		buttonsLeftCount = planetTray.count

		planetStack = setupPlanetTray(tray: planetTray)
		controlStack = setupControlTray(tray: controlTray)
		
		for button in planetStack {
			button.addTarget(self, action: #selector(planetButtonAction), for: .touchUpInside)
		}

		for button in controlStack {
			button.addTarget(self, action: #selector(controlButtonAction), for: .touchUpInside)
		}

		scroller?.removeFromSuperview() // for subsequent resets

		let stack = generateStack(tray1: planetStack, tray2: controlStack)
		scroller = UIScrollView()
		scroller.addSubview(stack)
		sceneView.addSubview(scroller)

		
		// scroller.rightAnchor.constraint(equalTo: liveViewSafeAreaGuide.rightAnchor).isActive = true



		setupAnchors(scroller: scroller, stack: stack, anchors: liveViewSafeAreaGuide)

		freezeTestButton()
	}

	override public func viewDidLoad() {
		super.viewDidLoad()

		sceneView = ARSCNView()
		sceneView.delegate = self
		sceneView.session.delegate = self
		sceneView.antialiasingMode = .multisampling4X
		sceneView.autoenablesDefaultLighting = true
 		//sceneView.debugOptions = [.showPhysicsShapes]

		let scene = SCNScene()

		/*
		background?.removeFromSuperview()
		background = BlackFilter()
		background.alpha = 0.8
		sceneView.addSubview(background)
		background.fillSuperview()
		*/
		sceneView.scene = scene

		self.view = sceneView
       	
		setupViews()
		
		scene.physicsWorld.contactDelegate = self
		

		let SolarSystem = SCNNode()
		SolarSystem.name = "container"
		scene.rootNode.addChildNode(SolarSystem)
		Solar.setSolarSystem(SolarSystem)
	}

	public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
		if let name = contact.nodeA.name, let name2 = contact.nodeB.name {
			if (name == "star" && name2 == "planet") || (name == "planet" && name2 == "star") {
				// TODO: Add a sparkle effect/sound on collision
				// Planet star collision
				AssesmentStatus.setFailMessage("**Uh oh!**\n\nYou did a collision between star and planet! This should not happen! Reset the solar system and try!")						

			} else if name == "planet" && name2 == "planet" {
				// Planet planet collision
				AssesmentStatus.setFailMessage("**Uh oh!**\n\nThis system is unstable as 2 planets could possibly collide. See for yourself which 2 planets collide, and reset your solar system to start again.")
				
			} else {
				AssesmentStatus.setFailMessage("**Uh oh!**\n\nCollision between \(name) and \(name2)")
			}
			testComplete(successful: false)
		}
	}

	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Create a session configuration
		let configuration = ARWorldTrackingConfiguration()
		
		configuration.planeDetection = .horizontal

		// Run the view's session
		sceneView.session.run(configuration)
	}

	override public func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Pause the view's session
		sceneView.session.pause()
	}
	
	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}

	public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

		let plane = Plane(planeAnchor)
		node.addChildNode(plane)
		planes[planeAnchor] = plane

		// AssesmentStatus.setPassMessage("**Nice work**\n\nYou've successfully located a plane for your solar system. Now its time to place **Sun** over there by tapping on the plane")
	}

	public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		if let plane = planes[planeAnchor] {
			plane.update(planeAnchor)
		}
	}

	override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		if testInProgress { return }
		if activeButton == nil { 
			AssesmentStatus.setFailMessage("**Hmm..**\n\nMake a star/planet selection first")	
			return 
		} 
		

		if let touch = touches.first {
			let touchLocation = touch.location(in: sceneView)

			let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)

			if let hitResult = results.first {

				if let activeTap = StaticData.getPlanet(name: activeButton.stringTag()!) {

					AssesmentStatus.setStatusToNil()
					let name = activeTap["name"] as! String
					let tilt: Float = Float(activeTap["axisTilt"] as! Double)

					// TODO: Check if planet is crashing with sun

					if name != "sun" && Solar.getStarCount() == 0 {
						AssesmentStatus.setFailMessage("**Uh oh**\nWe need a star in solar system before adding planet", "Click on Sun first and add it to your selected plane")
						return
					}

					var radius: Float
					var mass: Float
					if useOriginalRadius {
                    	radius = Float(activeTap["radius"] as! Double)
						mass = Float(activeTap["mass"] as! Double)
					} else {
                    	radius = Float(activeTap["saneRadius"] as! Double)
						mass = Float(activeTap["saneMass"] as! Double)
					}

					let x = hitResult.worldTransform.columns.3.x
					let y = hitResult.worldTransform.columns.3.y
					let z = hitResult.worldTransform.columns.3.z

					var position = SCNVector3(x: x, y: y, z: z)

					if name != "sun" {
						// add planet

						// position.y = Solar.getPositionY() // locking to same plane
						var planetSystem = Solar.addPlanet(absolutePosition: position, radius: radius, material: activeTap["file"] as! String, mass: mass, tilt: tilt)
								


						if name == "Saturn" {
							(planetSystem.childNode(withName: "planet-core", recursively: true) as! SCNNode).physicsBody?.categoryBitMask = 8
							sceneView.scene.rootNode.addChildNode(planetSystem)
							
							let rings = Solar.addPlanet(absolutePosition: position, radius: radius, material: "saturnrings.png", mass: mass, tilt: tilt, ring: true, big: useOriginalRadius)
							sceneView.scene.rootNode.addChildNode(rings)
							
							var updatedPosition = position
							updatedPosition.y = Solar.getPositionY()

							Solar.rotateAndRevolvePlanet(system: rings, ring: true)
							Solar.animatePlanetToCorrectPosition(rings, updatedPosition)
						} else {
							sceneView.scene.rootNode.addChildNode(planetSystem)
						}
						
						Solar.rotateAndRevolvePlanet(system: planetSystem)
						//}
						
						var updatedPosition = position
						updatedPosition.y = Solar.getPositionY()
						Solar.animatePlanetToCorrectPosition(planetSystem, updatedPosition)

						//AssesmentStatus.setPassMessage("**Awesome!**\nYour planet is added! See how smoothly it drifts in space. Let's explore something more!\n\n[**Next Page**](@next)", keepAlive: true)

					} else {
						let sun = Solar.addStar(absolutePosition: position, radius: radius, material: activeTap["file"] as! String)
						sceneView.scene.rootNode.addChildNode(sun)
					}

					activeButton.removeFromSuperview()
					activeButton = nil
					buttonsLeftCount -= 1

					if buttonsLeftCount == 0 {
						// all bodies are added. ready for test
						unFreezeTestButton()
					}
				} else {
                    AssesmentStatus.setFailMessage("Error selecting body: \(activeButton.stringTag() as! String). Select another body")
				}
			} else {
				AssesmentStatus.setFailMessage("**Hmm**\n\nTap on your chosen plane to place a body! You can always increase plane size by locating more plane in real world")
			}
		}
	}
}
