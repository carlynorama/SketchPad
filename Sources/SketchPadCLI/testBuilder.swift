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


           //let result = "Alice"
            //print(result)
            let fileContent = USDAFileBuilder(stage: HelloCanvas().stage)
            print(fileContent.generateStringFromStage())
            let path =  "testUSD_\(FileIO.timeStamp()).usd"
            FileIO.writeToFile(string:fileContent.generateStringFromStage(), filePath: path)
        }
    }
}
