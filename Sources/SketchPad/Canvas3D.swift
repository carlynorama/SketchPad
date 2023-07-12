//
//  Canvas3D.swift
//
//
//  Created by Carlyn Maw on 7/11/23.
//

//https://forums.swift.org/t/improved-result-builder-implementation-in-swift-5-8/63192
//https://developer.apple.com/videos/play/wwdc2021/10253/
import Foundation

public struct Canvas3D {
    let content:[Sphere]
    public init(@Canvas3DBuilder content: () -> [Sphere]) {
        self.content = content()
    }
}

//Result builder 'CanvasBuilder' does not implement any 'buildBlock' or a combination of 'buildPartialBlock(first:)' and 'buildPartialBlock(accumulated:next:)' with sufficient availability for this call site
//TODO: The new resultBuilder a la 
    //    extension SceneBuilder {
    //        static func buildPartialBlock(first: some Scene) -> some Scene
    //        static func buildPartialBlock(accumulated: some Scene, next: some Scene) -> some Scene
    //    }
@resultBuilder
public enum Canvas3DBuilder {

    public static func buildBlock(_ components: Sphere...) -> [Sphere] {
        components
    }
}

