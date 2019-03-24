import UIKit
import SceneKit

public enum Body: Int {
    case planet = 1
    case star = 2
    case ring = 4
    case planetWithRings = 8
}

public class HeavenlyBody {

    var SolarSystem: SCNNode!
    var StarNodeSystem: SCNNode!

    var starCount: Int! = 0

    var planets: [SCNNode]! = []
    var AssesmentStatus = ASHandler()

    public init() {

    }

    public func freezePlanets() {
        for planet in planets {
            // remove existing spins and transitions
            planet.removeAllActions()
            let raw = planet.childNode(withName: "planet-core", recursively: true) as! SCNNode
            raw.removeAllActions()
        }
        StarNodeSystem.childNode(withName: "star", recursively: true)!.removeAllActions()
    }

    public func setSolarSystem(_ system: SCNNode) {
        SolarSystem = system
    }

    func createGeometry(radius: Float, material materialName: String, allowAmbient: Bool = true) -> SCNSphere {
        let sphere = SCNSphere(radius: CGFloat(radius))
		let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: materialName)
        material.locksAmbientWithDiffuse = allowAmbient
        material.ambient.contents = UIColor.black
	    sphere.materials = [material]
        return sphere
    }

    public func addLightSource(position: SCNVector3, type: SCNLight.LightType, intensity: Int = 5000) -> SCNLight {
        let light = SCNLight()
        light.type = type
        light.intensity = 3000
        light.temperature = CGFloat(6000)
        light.categoryBitMask = Body.planet.rawValue
        return light
    }
    
    public func addStar(absolutePosition: SCNVector3, radius: Float, material: String) -> SCNNode {
        StarNodeSystem = SCNNode()
        var newPosition = absolutePosition
        newPosition.y = newPosition.y + radius + 0.1 // a little above our surface
        StarNodeSystem.position = newPosition
        StarNodeSystem.light = addLightSource(position: newPosition, type: .omni)

        let position = SolarSystem.convertPosition(newPosition, to: StarNodeSystem)

        let StarNode = SCNNode() 
        StarNode.position = position
        StarNode.geometry = createGeometry(radius: radius, material: material)
        StarNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        StarNode.categoryBitMask = Body.star.rawValue
        StarNode.physicsBody?.categoryBitMask = Body.star.rawValue
        StarNode.physicsBody?.contactTestBitMask = Body.planet.rawValue | Body.planetWithRings.rawValue | Body.ring.rawValue
        StarNode.physicsBody?.collisionBitMask = Body.planet.rawValue | Body.planetWithRings.rawValue | Body.ring.rawValue
        StarNode.physicsBody?.isAffectedByGravity = false
        StarNode.physicsBody?.restitution = 0
        starCount += 1

        StarNode.light = addLightSource(position: position, type: .ambient, intensity: 1000)

        StarNode.name = "star"
        StarNodeSystem.name = "star-system"
        StarNodeSystem.addChildNode(StarNode)
        StarNode.runAction(SlowAntiSpin())
        return StarNodeSystem
    }

    public func addBodyAtAbsolutePosition(absolutePosition: SCNVector3, radius: Float, material: String, ring: Bool) -> SCNNode {
        let Body = SCNNode()
        let rradius: Float = 0.2
        var newPosition = absolutePosition
        newPosition.y = newPosition.y + rradius
        Body.position = newPosition
        let planet = SCNNode()
        planet.geometry = createGeometry(radius: rradius, material: material)
        planet.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        Body.addChildNode(planet)
        planet.runAction(SlowRotation())

        if ring {
            var r = SCNTube(innerRadius: CGFloat(rradius + 0.01), outerRadius: CGFloat(rradius + 0.2), height: CGFloat(0.001))
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "saturnrings.png")
            r.materials = [material]
            let RingNode = SCNNode()
            RingNode.geometry = r
            RingNode.position = SCNVector3(x: 0, y: 0, z: 0)
            Body.addChildNode(RingNode)
            RingNode.rotation = SCNVector4Make(1, 0, 0, -0.46652651)
        }
        return Body
    }

    public func removePlanet(_ index: Int) {
        planets.remove(at: index)
    }

    public func removeStar() {
        starCount -= 1
        StarNodeSystem = nil
    }

    public func getPositionY() -> Float {
        return StarNodeSystem.position.y
    }

    public func getStarRadius() -> Float {
        return Float((StarNodeSystem.childNode(withName: "star", recursively: true)!.geometry as! SCNSphere).radius)
    }

    public func getStarPosition() -> SCNVector3 {
        return StarNodeSystem.position
    }

    public func addPlanet(absolutePosition: SCNVector3, radius: Float, material: String, mass: Float, tilt: Float, ring: Bool = false, big: Bool = false) -> SCNNode {
        var newPosition = absolutePosition
        newPosition.y = newPosition.y + radius
		var position = SolarSystem.convertPosition(newPosition, to: StarNodeSystem!)
        var planet = SCNNode()
        var planetShell = SCNNode()
        if ring {
            var ring = SCNTube(innerRadius: CGFloat(radius + 0.01), outerRadius: CGFloat(radius + 0.11), height: CGFloat(0.001))
            
            if big {
                ring.innerRadius = CGFloat(radius + 0.07)
                ring.outerRadius = CGFloat(radius + 0.23)
                ring.height = CGFloat(0.002)
            }

            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "saturnrings.png")
            ring.materials = [material]

            planet.geometry = ring

            planet.categoryBitMask = Body.planet.rawValue
            planet.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            planet.physicsBody?.categoryBitMask = Body.ring.rawValue
            planet.physicsBody?.collisionBitMask = Body.planet.rawValue | Body.star.rawValue
            planet.physicsBody?.contactTestBitMask = Body.planet.rawValue | Body.star.rawValue
            planetShell.name = "planet-ring"
        } else {
            planet.geometry = createGeometry(radius: radius, material: material, allowAmbient: false)
            planet.categoryBitMask = Body.planet.rawValue
            planet.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            planet.physicsBody?.categoryBitMask = Body.planet.rawValue
            planet.physicsBody?.collisionBitMask = Body.planet.rawValue | Body.star.rawValue | Body.planetWithRings.rawValue
            planet.physicsBody?.contactTestBitMask = Body.planet.rawValue | Body.star.rawValue | Body.planetWithRings.rawValue
            planetShell.name = "planet"
        }
        planet.name = "planet-core"
        planet.physicsBody?.restitution = 0
        planet.physicsBody?.isAffectedByGravity = false
        planetShell.rotation = SCNVector4Make(1, 0, 0, tilt)
        planetShell.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        planetShell.physicsBody?.categoryBitMask = 16
        planetShell.physicsBody?.collisionBitMask = 0
        planetShell.physicsBody?.contactTestBitMask = 0

        planetShell.position = position
        planetShell.addChildNode(planet)

        let StarPlanetSystem = SCNNode()
        StarPlanetSystem.position = StarNodeSystem.position

        StarPlanetSystem.name = "planet-system"
        StarPlanetSystem.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        StarPlanetSystem.physicsBody?.mass = CGFloat(mass)

        

        StarPlanetSystem.addChildNode(planetShell)

        planets.append(StarPlanetSystem)

        return StarPlanetSystem
    }


    public func rotateAndRevolvePlanet(system: SCNNode, ring: Bool = false, delay: Double = 2) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { // for 2 second path correction of planet
            if ring {
                let rawPlanet = system.childNode(withName: "planet-core", recursively: true) as! SCNNode
                rawPlanet.runAction(VerySlowRotation())
                system.runAction(NormalRevolve())
            } else {
                let rawPlanet = system.childNode(withName: "planet-core", recursively: true) as! SCNNode
                rawPlanet.runAction(SlowRotation())
                system.runAction(NormalRevolve())
            }
        })
    }

    public func animatePlanetToCorrectPosition(_ planetSystem: SCNNode, _ position: SCNVector3) {
        let position = SolarSystem.convertPosition(position, to: StarNodeSystem!)
        (planetSystem.childNode(withName: "planet", recursively: true) as? SCNNode)?.runAction(SCNAction.move(to: position, duration: 2))
        (planetSystem.childNode(withName: "planet-ring", recursively: true) as? SCNNode)?.runAction(SCNAction.move(to: position, duration: 2))
    }

    public func getOrbitalRadius(_ planet: SCNNode) -> Float {
        //let pos1 = StarNodeSystem.convertPosition(planet.position, to: SolarSystem!)
        var node: SCNNode!
        if let test = planet.childNode(withName: "planet", recursively: true) as? SCNNode {
            node = test
        } else {
            node = planet.childNode(withName: "planet-ring", recursively: true) as? SCNNode
        }
        let pos1 = StarNodeSystem.convertPosition(node!.position, to: SolarSystem!)
        let pos2 = StarNodeSystem.position

   	   //  AssesmentStatus.setPassMessage("\(pos2) - \(pos1)", keepAlive: true)
        let distance = SCNVector3(
            pos2.x - pos1.x,
            pos2.y - pos1.y,
            pos2.z - pos1.z
        )


   	    // AssesmentStatus.setPassMessage("\(pos2) - \(pos1) = \( sqrtf(distance.x * distance.x + distance.y * distance.y + distance.z * distance.z) )", keepAlive: true)

        return sqrtf(distance.x * distance.x + distance.y * distance.y + distance.z * distance.z)
    }

    public func softResetSystem() {
        planets.removeAll()
        starCount = 0
        StarNodeSystem = nil 
    }

    public func getAllPlanets() -> [SCNNode] {
        return planets
    }

    public func getPlanetCount() -> Int {
        return planets.count
    }

    public func getBodyCount() -> Int {
        return planets.count + starCount
    }

    public func getStarCount() -> Int {
        return starCount
    }
}