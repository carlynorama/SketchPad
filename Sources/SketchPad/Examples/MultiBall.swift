//
//  HelloCanvas.swift
//
//
//  Created by Carlyn Maw on 7/11/23.
//

public struct MultiBallStage {
    public init(count:Int) {
        self.count = count
    }
    let count:Int
    let minTranslate = -4.0
    let maxTranslate = 4.0
    let minRadius = 0.8
    let maxRadius = 2.0

    public func buildStage() -> Canvas3D {
        Canvas3D {
            Sphere(radius: 1.0).color(red: 0, green: 0, blue: 1.0)
             for _ in 0..<count {
                 Sphere(radius: Double.random(in: minRadius...maxRadius))
                 .color(
                     red: Double.random(in: 0...1), 
                     green: Double.random(in: 0...1), 
                     blue: Double.random(in: 0...1)
                 )
                 //The ranges are all the same in this case. 
                 .translateBy(Vector.random(range: minTranslate...maxTranslate))
             }
        }
    } 

}
