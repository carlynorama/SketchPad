//
//  File.swift
//  
//
//  Created by Carlyn Maw on 7/11/23.
//

//https://forums.swift.org/t/improved-result-builder-implementation-in-swift-5-8/63192

import Foundation

//struct Scene {
//    var geometries:[any Geometry]
//}

@resultBuilder
public struct SceneBuilder {
    static func buildBlock(_ components: any Geometry...) -> [any Geometry] {
        components
    }

//    static func buildOptional(_ component:any Geometry?) -> [any Geometry] {
//        component ?? []
//    }

    static func buildEither(first component: any Geometry) -> [any Geometry] {
        return [component]
    }

    static func buildEither(second component: any Geometry) -> [any Geometry] {
        return [component]
    }

    static func buildArray(_ components: [any Geometry]) -> [any Geometry] {
        components
    }
}

