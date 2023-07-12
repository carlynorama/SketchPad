//
//  SketchPadCLI/tesBuilder.swift
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
               Sphere(radius:0.5).color(red:0.5, green:0.5, blue:1.0)
           }

           //let result = "Alice"
            //print(result)
            let fileContent = USDAFileBuilder(stage: result)
            print(fileContent.generateStringFromStage())
            let path =  "testUSD_\(FileIO.timeStamp()).usd"
            FileIO.writeToFile(string:fileContent.generateStringFromStage(), filePath: path)
        }
    }
}
