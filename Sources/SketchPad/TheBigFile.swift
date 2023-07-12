
// Canvas3D {
//     Sphere(radius:3.0)
            //.place(x:2.0, y:1.0, z:4.0)
            //.color(red:0.1, green:0.2, blue:0.5)
// }

//Not yet.
//import simd
import Foundation

//TODO: UUID sucks as a geometry ID

enum IdString {
    static func make(prefix:String) -> String {
        "\(prefix)_\(Int.random(in: 10000..<100000))"
    }
    // let value:String

    // init(prefix:String) {
    //     self.value = "\(prefix)_\(Int.random(in: 10000..<100000))"
    // }    
}

public struct Vector {
    let x:Double
    let y:Double
    let z:Double
    
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
}

// try to match behavior of
// https://developer.apple.com/documentation/modelio/mdlaxisalignedboundingbox
public struct Bounds3D {
    var minBounds:Vector
    var maxBounds:Vector
}

public protocol Geometry:Transformable & Boundable {
    var id:String { get }
    var shapeName:String { get }
}

public enum Transformation {
    case translate(Vector)
}

public protocol Boundable {
    var currentBounds:Bounds3D { get }
}

public protocol Transformable {
    var transformations:[Transformation] { get set }
    mutating func translateBy(_ vector:Vector) -> Self
}
public extension Transformable {
    func translateBy(_ vector: Vector) -> Self {
        var copy = self
        copy.transformations.append(.translate(vector))
        return copy
    }
}
//extension Transformable {
    // func translateTo(x:Double, y:Double, z:Double) {}
    // func translateTo(_ vector:Vector) {}
    // func translateBy(x:Double, y:Double, z:Double) {}
    // func translateBy(_ vector:Vector) {}

    // func rotateBy(x:Double, y:Double, z:Double) {}
    // func rotateBy(v:Vector) {}

    // func scaleBy(_ onDiagonal:Double) {}
    // func scaleBy(x:Double, y:Double, z:Double) {}
    // func scaleBy(_ vector:Vector) {}
    // func scaleTo(x:Double, y:Double, z:Double) {}
//}

public protocol Surfaceable {
    func diffuseColor(red:Double, green:Double, blue:Double)
    func emissiveColor(red:Double, green:Double, blue:Double)
}

public enum Surfaces {
    case diffuseColor((r:Double, g:Double, b:Double))
    case emissiveColor((r:Double, g:Double, b:Double))
    case metallic(Double)
}


public struct Sphere:Geometry {
    static var shapeName = "Sphere"
    public let id:String = IdString.make(prefix: Self.shapeName)
    let radius:Double
    
    public var shapeName: String {
        Self.shapeName
    }
    
    public init(radius: Double, transformations:[Transformation] = []) {
        self.radius = radius
        self.transformations = transformations
    }

    //Boundable
    public var currentBounds: Bounds3D {
        let minVect = Vector(x: -radius, y: -radius, z: -radius)
        let maxVect = Vector(x: radius, y: radius, z: radius)
        return Bounds3D(minBounds: minVect, maxBounds: maxVect)
    }

    //Transformable
    public var transformations:[Transformation] = []

    
    //Surfaceable
    public var surfaces:[Surfaces] = []
    
}

// struct Cube:Geometry {
//     let side:Double

//     var transformations:[Transformation]
// }

// struct Box:Geometry {
//     let side_x:Double
//     let side_y:Double
//     let side_z:Double

//     var transformations:[Transformation]
// }

// struct Cone:Geometry {
//     let base_radius:Double
//     let height:Double

//     var transformations:[Transformation]
// }
