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