import UIKit

var earthRadius = 0.03

var sun: Dictionary<String, Any> = [
    "file": "sun.jpg",
    "radius": earthRadius * 10,
    "saneRadius": 0.12,
    "name": "sun",
    "mass": 10.01,
    "saneMass": 3.01,
    "axisTilt": 0.1265364
]

var mercury: Dictionary<String, Any> = [
    "file": "mercury.jpg",
    "radius": earthRadius * 0.6,
    "saneRadius": 0.05,
    "name": "Mercury",
    "mass": 0.0553,
    "saneMass": 0.5,
    "axisTilt": 0.0005235988
]

var venus: Dictionary<String, Any> = [
    "file": "venus.jpg",
    "radius": earthRadius * 0.95,
    "saneRadius": 0.05,
    "name": "Venus",
    "mass": 0.815,
    "saneMass": 0.6,
    "axisTilt": 0.04607669
]

var earth: Dictionary<String, Any> = [
    "file": "earth.jpg",
    "radius": earthRadius,
    "saneRadius": 0.05,
    "name": "Earth",
    "mass": 1.01,
    "saneMass": 1.01,
    "axisTilt": 0.40910518
]

var mars: Dictionary<String, Any> = [
    "file": "mars.jpg",
    "radius": earthRadius * 0.5,
    "saneRadius": 0.05,
    "name": "Mars",
    "mass": 0.11,
    "saneMass": 1.01,
    "axisTilt": 0.43964844
]

var jupiter: Dictionary<String, Any> = [
    "file": "jupiter.jpg",
    "radius": earthRadius * 6.5,
    "saneRadius": 0.07,
    "name": "Jupiter",
    "mass": 317.8,
    "saneMass": 2.01,
    "axisTilt": 0.05462881
]

var saturn: Dictionary<String, Any> = [
    "file": "saturn.jpg",
    "radius": earthRadius * 5.5,
    "saneRadius": 0.06,
    "name": "Saturn",
    "mass": 95.2,
    "saneMass": 1.6,
    "axisTilt": 0.46652651
]

var uranus: Dictionary<String, Any> = [
    "file": "uranus.jpg",
    "radius": earthRadius * 2.5,
    "saneRadius": 0.06,
    "name": "Uranus",
    "mass": 14.6,
    "saneMass": 1.2,
    "axisTilt": 1.4351842
]

var neptune: Dictionary<String, Any> = [
    "file": "neptune.jpg",
    "radius": earthRadius * 2.5,
    "saneRadius": 0.05,
    "name": "Neptune",
    "mass": 17.2,
    "saneMass": 1.5,
    "axisTilt": 0.49427724
]

var planetInfo: Dictionary<String, Dictionary<String, Any>> = [
    "sun": sun,
    "mercury": mercury,
    "venus": venus,
    "earth": earth,
    "mars": mars,
    "jupiter": jupiter,
    "saturn": saturn,
    "uranus": uranus,
    "neptune": neptune
]

public class StaticData {
    public static func getPlanet(name: String) -> Dictionary<String, Any>? {
        return planetInfo[name]
    }
}