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
    struct multiball:ParsableCommand {
        
        static var configuration =
        CommandConfiguration(abstract: "Generate a USDA file that references sphere_base.usda like previous examples")
        
        func run() {
            print(generateMultiBallUSDText(count:12))
        }
        
    }
}
