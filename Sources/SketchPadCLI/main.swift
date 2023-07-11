import Foundation
import ArgumentParser

//@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 6, *)
struct SketchPadCLI: ParsableCommand {
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


