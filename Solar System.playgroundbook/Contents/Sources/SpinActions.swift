import SceneKit

func sigmoid(_ z: Double) -> Double {
    return 1.0 / (1.0 + exp(-z))
}

public func SlowRotation() -> SCNAction {
    return SCNAction.repeatForever(
        SCNAction.rotateBy(
            x: 0,
            y: .pi,
            z: 0,
            duration: 3
        )
    )
}

public func VerySlowRotation() -> SCNAction {
    return SCNAction.repeatForever(
        SCNAction.rotateBy(
            x: 0,
            y: .pi,
            z: 0,
            duration: 3000
        )
    )
}


public func SlowRevolution() -> SCNAction {
    return SCNAction.repeatForever(
        SCNAction.rotateBy(
            x: 0,
            y: .pi,
            z: 0,
            duration: 60
        )
    )
}

public func SlowAntiRevolution() -> SCNAction {
    return SCNAction.repeatForever(
        SCNAction.rotateBy(
            x: 0,
            y: -.pi,
            z: 0,
            duration: 60
        )
    )
}


public func SlowAntiSpin() -> SCNAction {
    return SCNAction.repeatForever(
        SCNAction.rotateBy(
            x: 0,
            y: -.pi,
            z: 0,
            duration: 20
        )
    )
}

public func NormalSpin() -> SCNAction {
    return SCNAction.repeatForever(
        SCNAction.rotateBy(
            x: 0,
            y: .pi,
            z: 0,
            duration: 1
        )
    )
}

public func NormalRevolve() -> SCNAction {
    return SCNAction.repeatForever(
        SCNAction.rotateBy(
            x: 0,
            y: .pi,
            z: 0,
            duration: 8
        )
    )
}

public func FastRevolution(distance: Float, mass: Float, reverse: Bool = false) -> SCNAction {

    var unity = 1
    if reverse {
        unity = -1
    }

    let mulFactor = pow(distance.squareRoot(), 3)

    //print("\(mulFactor)")
    
    
    var AssesmentStatus = ASHandler()
   
   	// AssesmentStatus.setPassMessage("\(distance)", keepAlive: true)

    return SCNAction.repeatForever(
        SCNAction.rotateBy(
            x: 0,
            y: CGFloat(unity) * .pi,
            z: 0,
            duration: 2*Double(mulFactor)
        )
    )
}

public func FastRotation() -> SCNAction {
    var AssesmentStatus = ASHandler()
    return SCNAction.repeatForever(
        SCNAction.rotateBy(
            x: 0,
            y: .pi * 2,
            z: 0,
            duration: 1
        )
    )
}