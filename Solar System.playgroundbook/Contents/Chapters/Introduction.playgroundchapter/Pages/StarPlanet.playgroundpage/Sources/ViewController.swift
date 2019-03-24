import UIKit
import SceneKit
import ARKit
import PlaygroundSupport

public class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate, PlaygroundLiveViewSafeAreaContainer {
	var sceneView: ARSCNView!	
	var planeCount = 0
	let AssesmentStatus = ASHandler()
	let Solar = HeavenlyBody()
	var scroller: UIScrollView!
	var planes = [ARPlaneAnchor: Plane]()
	var finished: Bool! = false
	var planetStack: [UIButton]! = []
	var controlStack: [UIButton]! = []
	var activeButton: UIButton!
	var useOriginalRadius: Bool! = true

    var activePlanet: String! = "sun"

	@objc
	func planetButtonAction(sender: UIButton!) {
		for btn in planetStack {
			btn.alpha = 0.3
		}
		sender.alpha = 1
		activeButton = sender
	}

	func unFreezeButtons() {
		for btn in planetStack {
			btn.isEnabled = true
		}
		for btn in controlStack {
			btn.isEnabled = true
		}
	}

	@objc
	func controlButtonAction(sender: UIButton!) {
		if let tag = sender.stringTag() {
			if tag == "Reset" {
                resetScene()
            }
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
		setupViews()
		unFreezeButtons()
		Solar.softResetSystem()
		planeCount = 0
		//AssesmentStatus.setStatusToNil()
	}

	public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

		let plane = Plane(planeAnchor)
		node.addChildNode(plane)
		planes[planeAnchor] = plane

		//AssesmentStatus.setPassMessage("**Nice work**\n\nYou've successfully located a plane for your solar system! This would now contain our heavenly bodies. Let's go!\(getNextPage())", keepAlive: true)
	}

	public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		if let plane = planes[planeAnchor] {
			plane.update(planeAnchor)
		}
	}

    public func makeOnlyAvailable(name: String) {
        activePlanet = name
    }

	public func setOriginalScale(_ val: Bool) {
		useOriginalRadius = val
	}

	func setupViews() {
		let planetTray = ["sun", "\(activePlanet!)"]
		let controlTray = ["Reset"]

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

		setupAnchors(scroller: scroller, stack: stack, anchors: liveViewSafeAreaGuide)
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
			Solar.freezePlanets()
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

	override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		if finished { return }

		if activeButton == nil { 
			AssesmentStatus.setFailMessage("**Hmm..**\n\nMake a star/planet selection first from the panel on right of screen", "Click on sun icon on right and then place it in your real world")	
			return 
		}

		if let touch = touches.first {
			let touchLocation = touch.location(in: sceneView)

			let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)

			if let hitResult = results.first {
				if let activeTap = StaticData.getPlanet(name: activeButton.stringTag() as! String) {



					
                    let name = activeTap["name"] as! String
					var radius: Float
					var mass: Float
					if useOriginalRadius {
                    	radius = Float(activeTap["radius"] as! Double)
						mass = Float(activeTap["mass"] as! Double)
					} else {
                    	radius = Float(activeTap["saneRadius"] as! Double)
						mass = Float(activeTap["saneMass"] as! Double)
					}

					if name != "sun" && Solar.getStarCount() == 0 {
						AssesmentStatus.setFailMessage("**Uh oh**\nWe need a star in solar system before adding planet", "Click on Sun first and add it to your selected plane")
						return
					}


					let tilt: Float = Float(activeTap["axisTilt"] as! Double)
					
                    let x = hitResult.worldTransform.columns.3.x
                    let y = hitResult.worldTransform.columns.3.y
                    let z = hitResult.worldTransform.columns.3.z

                    var position = SCNVector3(x: x, y: y, z: z)
					var body: SCNNode!

					if name != "sun" {
						// add planet

						// position.y = Solar.getPositionY() // locking to same plane
						var planetSystem = Solar.addPlanet(absolutePosition: position, radius: radius, material: activeTap["file"] as! String, mass: mass, tilt: tilt)
								


						if name == "Saturn" {
							(planetSystem.childNode(withName: "planet", recursively: true) as! SCNNode).physicsBody?.categoryBitMask = 8
							sceneView.scene.rootNode.addChildNode(planetSystem)
							
							let rings = Solar.addPlanet(absolutePosition: position, radius: radius, material: "saturnrings.png", mass: mass, tilt: tilt, ring: true)
							sceneView.scene.rootNode.addChildNode(rings)
							
							var updatedPosition = position
							updatedPosition.y = Solar.getPositionY()

							Solar.animatePlanetToCorrectPosition(rings, updatedPosition)
							Solar.rotateAndRevolvePlanet(system: rings, ring: true)
						} else {
							sceneView.scene.rootNode.addChildNode(planetSystem)
						}
							
							var updatedPosition = position
							updatedPosition.y = Solar.getPositionY()
							
							Solar.animatePlanetToCorrectPosition(planetSystem, updatedPosition)
							Solar.rotateAndRevolvePlanet(system: planetSystem)
							//}

							finished = true
							AssesmentStatus.setPassMessage("**Nice!**\n\nSee how this planet is spinning around the star you added\(getNextPage())", keepAlive: true)
							//AssesmentStatus.setPassMessage("**Awesome!**\nYour planet is added! See how smoothly it drifts in space. Let's explore something more!\n\n[**Next Page**](@next)", keepAlive: true)

					} else {
						let sun = Solar.addStar(absolutePosition: position, radius: radius, material: activeTap["file"] as! String)
						sceneView.scene.rootNode.addChildNode(sun)
					}

						activeButton.removeFromSuperview()
						activeButton = nil
                } else {
                    AssesmentStatus.setFailMessage("Error selecting body: \(activeButton.stringTag() as! String). Select another body")
                }
            } else {
				AssesmentStatus.setFailMessage("**Hmm**\n\nTap on your chosen plane to place a body! You can always increase plane size by locating more plane in real world")
			}
		}
	}
}
