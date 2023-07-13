//
//  SketchPadCLI/multiball.swift
//
//
//  Created by Carlyn Maw on 7/11/23.
//

import Foundation
import ArgumentParser
import SketchPad


extension SketchPadCLI {
    struct multiball:ParsableCommand {
        @Flag(name: [.customLong("save"), .customShort("s")], help: "Will save to file called \"multiball_$TIMESTAMP.usda\" instead of printing to stdout")
        var saveToFile = false
        
        @Option(name: [.customLong("output"), .customShort("o")], help: "Will save to custom path instead of printing to stdout")
        var customPath:String? = nil
        
        @Option(name: [.customLong("count"), .customShort("c")],
              help: "Number of spheres to generate in addition to the blue origin sphere. Default is 12")
        var count:Int = 12
        
        
        static var configuration =
        CommandConfiguration(abstract: "Generate a USDA file that references sphere_base.usda like previous examples. 12 + blue origin ball is the default count")
        
        func run() {
            let fileBuilder = USDAFileBuilder()
            let fileString:String = fileBuilder.generateStringForStage(stage: MultiBallStage(count:count).buildStage())
            if saveToFile || customPath != nil {
                do {
                    guard let data:Data = fileString.data(using: .utf8) else {
                        print("Could not encode string to data")
                        return
                    }
                let path:String = customPath ?? "multiball_\(FileIO.timeStamp()).usda"
                    try FileIO.writeToFile(data: data, filePath: path)
                } catch {
                    print("Could not write data to file: \(error)")
                }
            } else {
                print(fileString)
            }
        }
        
    }
}
