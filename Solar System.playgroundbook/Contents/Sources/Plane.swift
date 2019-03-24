import SceneKit
import ARKit

public class Plane: SCNNode {
    var planeAnchor: ARPlaneAnchor
    
    var planeGeometry: SCNPlane
    var planeNode: SCNNode

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public init(_ anchor: ARPlaneAnchor) {
        
        self.planeAnchor = anchor
        
        let grid = UIImage(named: "grid.png")
        let newWidth = CGFloat(anchor.extent.x)
        let newHeight = CGFloat(anchor.extent.z)
        self.planeGeometry = SCNPlane(width: newWidth, height: newHeight)

        let material = SCNMaterial()
        material.diffuse.contents = grid
        material.diffuse.wrapS = SCNWrapMode.repeat
        material.diffuse.wrapT = SCNWrapMode.repeat
        // size
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(64, 64, 0)
        material.transparency = 0.5

        self.planeGeometry.materials = [material]
        
        self.planeNode = SCNNode(geometry: planeGeometry)
        self.planeNode.eulerAngles.x = -.pi / 2
        
        super.init()
        
        self.addChildNode(planeNode)
        
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }

    public func update(_ anchor: ARPlaneAnchor) {
        self.planeAnchor = anchor

        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)

        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)		
    }
}