
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
    struct testing:ParsableCommand {
        
        func run() {
            
            
            //let result = "Alice"
            //print(result)
            let builder = USDAFileBuilder()
//           let stage = HelloCanvas().buildStage()
//            print(builder.generateStringForStage(stage:stage))
//            let path =  "testUSD_\(FileIO.timeStamp()).usd"
//            FileIO.writeToFile(string:builder.generateStringForStage(stage:stage), filePath: path)

            let layerStage = ScratchPad().buildStage()
            print(layerStage)
            //print(builder.generateStringForStage(stage: layerStage))
            let path_l = "testLayerUSD_\(FileIO.timeStamp()).usd"
            FileIO.writeToFile(string:builder.generateString(for:layerStage), filePath: path_l)
            
            let results = layerStage._walk(items: [])
            print(results)
            
            let builderX3D = X3DFileBuilder()
            print(builderX3D.generateString(for: layerStage))
            let path_x3d = "layers_\(FileIO.timeStamp()).x3d"
            FileIO.writeToFile(string:builderX3D.generateString(for: layerStage), filePath: path_x3d)

        }
    }
}
