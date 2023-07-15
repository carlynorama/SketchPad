//
//  StringBuilder.swift
//
//
//  Created by Carlyn Maw on 7/10/23.
//

// TODO: Multiline strings?
// TODO: Fix empty line for ifs (switch to [String]... ?)
// TODO: Ignore empty lines as an option? 

import Foundation

@resultBuilder
struct StringBuilder {
    static func buildBlock(_ parts: String...) -> String {
        parts.joined(separator: "\n")
    }

    
    static func buildOptional(_ component:String?) -> String {
        component ?? ""
    }

    static func buildEither(first component: String) -> String {
        return component
    }

    static func buildEither(second component: String) -> String {
        return component
    }

    static func buildArray(_ components: [String]) -> String {
        components.joined(separator: "\n")
    }
}

// @resultBuilder
// struct <#Name#>Builder {
//     typealias Expression = <#Expression#>
//     typealias Component = <#Component#>
//     typealias FinalResult = <#FinalResult#>

//     static func buildBlock(_ components: Component...) -> Component {
//         buildArray(components)
//     }
//     static func buildExpression(_ expression: Expression) -> Component {

//     }
//     static func buildOptional(_ component: Component?) -> Component {
//         component ?? <#empty#>
//     }
//     static func buildEither(first component: Component) -> Component {
//         component
//     }
//     static func buildEither(second component: Component) -> Component {
//         component
//     }
//     static func buildArray(_ components: [Component]) -> Component {

//     }
//     static func buildLimitedAvailability(_ component: Component) -> Component {
//         component
//     }
//     static func buildFinalResult(_ component: Component) -> FinalResult {

//     }
// }