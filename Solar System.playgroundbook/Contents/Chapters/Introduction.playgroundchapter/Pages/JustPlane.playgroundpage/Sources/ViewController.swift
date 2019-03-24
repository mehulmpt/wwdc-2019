import UIKit
import SceneKit
import ARKit
import PlaygroundSupport

public class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate, PlaygroundLiveViewSafeAreaContainer {
	var sceneView: ARSCNView!	
	let AssesmentStatus = ASHandler()
	var planes = [ARPlaneAnchor: Plane]()

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

		AssesmentStatus.setPassMessage("**Nice work**\n\nYou've successfully located a plane for your solar system! This would now contain our heavenly bodies. You can keep locating more area if you want. Let's go!\(getNextPage())", keepAlive: true)
	}

	public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		if let plane = planes[planeAnchor] {
			plane.update(planeAnchor)
		}
	}
}
