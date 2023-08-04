#SketchPad

CLI and Library for generating 3D asset files with a SwiftUI-like DSL.


The focus is .usda files, but also can generate X3D files.

## Example Usage

```swift
public struct RandomShell {
    public init(count:Int, radius:Double, ratio:Double = 0.1) {
        self.count = count
        self.radius = radius
        self.ratio = ratio
    }
    let count:Int
    let radius:Double
    let ratio:Double

    //TODO: Should be static on Canvas3D
    let tau = Double.pi * 2
    let π = Double.pi

    //public func buildStage() -> Stage {
    public func buildStage() -> some Layer {
        let sun_color = 0.9
        let sphere_radius = radius*ratio
        return Stage {
            Sphere(radius: sphere_radius).color(red: sun_color, green: sun_color, blue: sun_color)
             for _ in 0..<count {
                 let theta = Double.random(in: 0...π)
                 let phi = Double.random(in: 0...tau)
                 let x = radius * sin(theta) * cos(phi)
                 let y = radius * sin(theta) * sin(phi)
                 let z = radius * cos(theta)
                 
                 Sphere(radius: sphere_radius)
                 .color(
                    red: cos(phi).magnitude,//theta/tau,
                     green: cos(theta).magnitude, //Double.random(in: 0...1),
                    blue: sin(phi).magnitude //tau/theta
                 )
                 .translateBy(Vector(x: x, y: y, z: z))
             }
        }
    }
}
```

Can be called / saved to file via code like 

```swift
let layerStage = RandomShell().buildStage()

let usdabuilder = USDAFileBuilder()
let path_usd = "shell_\(FileIO.timeStamp()).usd"
FileIO.writeToFile(string:usdabuilder.generateStringForStage(stage:layerStage), filePath: path_usd)

let x3dbuilder = X3DFileBuilder()
let path_x3d = "shell_\(FileIO.timeStamp()).x3d"
FileIO.writeToFile(string:x3dbuilder.generateStringForStage(stage:layerStage), filePath: path_x3d)
```

## Upcoming Roadmap
- [x] rewrite to allow for multiple primitive types
- [] update tests to reflect refactor
- [] add optional "[USDServiceProvider](https://github.com/carlynorama/USDServiceProvider)" to check files / make crates for importing into other Swift projects.  
- [] fix adding colors / materials
- [] add additional primitives
- [] make an "Assembly" or other group type
- [] make an "over" 
- [] add meshes
- [] add camera



