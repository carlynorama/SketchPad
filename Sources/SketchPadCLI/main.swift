import Foundation
import ArgumentParser


struct SketchPadCLI: AsyncParsableCommand {
     static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to create 3D files from simple instructions",
        version: "0.0.1",
        subcommands: [
            multiball.self,
        ],
        defaultSubcommand: multiball.self)

    init() { }
}

SketchPadCLI.main()


