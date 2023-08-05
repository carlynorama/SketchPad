//
//  SketchPadCLI/main.swift
//
//
//  Created by Carlyn Maw on 7/11/23.
//
import Foundation
import ArgumentParser

//TODO: AsyncParsableCommand

//TARGET UI -
//- sketchpad multiball -q 12 -o fileName
//- sketchpad multiball -q 12 -o fileName.ext or -t ext

//@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 6, *)
struct SketchPadCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to create 3D files from simple instructions",
        version: "0.0.1",
        subcommands: [
            multiball.self,
            hello.self,
            testing.self,
            sketchondeck.self
        ],
        defaultSubcommand: testing.self)
    //defaultSubcommand: testBuilder.self)
    
    init() { }
}

SketchPadCLI.main()


