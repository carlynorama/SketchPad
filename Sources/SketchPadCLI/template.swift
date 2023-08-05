//
//  SketchPadCLI/template.swift
//
//
//  Created by Carlyn Maw on 7/11/25.
//

import Foundation
import ArgumentParser
import SketchPad


extension SketchPadCLI {
    struct template:ParsableCommand {
        
        static let sketch = LatLongSatellites(meridianCount: 10, parallelCount: 10, radius: 12)
        static let fileNameStub = "satellites"
        
        @Flag(name: [.customLong("save"), .customShort("s")], help: "Will save to file called \"\(Self.fileNameStub)_$TIMESTAMP.usda\" instead of printing to stdout")
        var saveToFile = false
        
        @Option(name: [.customLong("output"), .customShort("o")], help: "Will save to custom path instead of printing to stdout")
        var customPath:String? = nil
        
        @Option(name: [.customLong("count"), .customShort("c")],
                help: "Number of spheres to generate in addition to the blue origin sphere. Default is 12")
        var count:Int = 199
        
        @Option(name: [.customLong("radius"), .customShort("r")],
                help: "Number of spheres to generate in addition to the blue origin sphere. Default is 12")
        var radius:Double = 12
        
        
        static var configuration =
        CommandConfiguration(abstract: "Generate a USDA file that references sphere_base.usda like previous examples. 12 + blue origin ball is the default count")
        
        func run() {
            
            let stage = Self.sketch.buildStage()
            
            let fileBuilder_x3d = X3DFileBuilder()
            let fileString_x3d:String = fileBuilder_x3d.generateString(for: stage)
            
            let fileBuilder_usd = USDAFileBuilder()
            let fileString_usd:String = fileBuilder_usd.generateString(for: stage)
            
            if saveToFile || customPath != nil {
                let timeStamp = FileIO.timeStamp()
                let path = customPath ?? "\(Self.fileNameStub)_\(timeStamp).usda"
                saveFile(fileString: fileString_usd, path: path)
                let path_x3d = "\(Self.fileNameStub)_\(timeStamp).x3d"
                saveFile(fileString: fileString_x3d, path: path_x3d)
            } else {
                print(fileString_usd)
                print("------------------")
                print(fileString_x3d)
            }
        }
        
        func saveFile(fileString:String, path:String, ext:String? = nil) {
            do {
                guard let data:Data = fileString.data(using: .utf8) else {
                    print("Could not encode string to data")
                    return
                }
                var fullPath:String
                if let ext {
                    fullPath = "\(path).\(ext)"
                } else {
                    fullPath = path
                }
                try FileIO.writeToFile(data: data, filePath: fullPath)
            } catch {
                print("Could not write data to file: \(error)")
            }
        }
    }
    
    
}
