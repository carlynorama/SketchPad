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
    struct hello:ParsableCommand {
        
        func run() {
            let builder = USDAFileBuilder()
            let stage = Hello().buildStage()
            print(builder.generateString(for:stage))
            let path =  "testUSD_\(FileIO.timeStamp()).usd"
            FileIO.writeToFile(string:builder.generateString(for:stage), filePath: path)
        }
    }
}
