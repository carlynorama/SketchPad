//
//  File.swift
//
//
//  Created by Carlyn Maw on 7/11/23.
//

import Foundation
import ArgumentParser
import SketchPad

extension SketchPadCLI {
    struct testBuilder:ParsableCommand {
        
        func run() {
           let result = Canvas3D {
               Sphere(radius:1).translateBy(Vector(x:3, y: 2, z: 5))
               Sphere(radius:1)
           }
            //let result = "Alice"
            print(result)
        }
    }
}
