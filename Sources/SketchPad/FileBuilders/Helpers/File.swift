//
//  File.swift
//
//
//  Created by Carlyn Maw on 7/16/23.
//
//
//import Foundation
//
//indirect enum StringNode {
//    case content(String)
//    case container((prefix:String, content:StringNode, suffix:String))
//
//    init(_ string:String) {
//        self = .content(string)
//    }
//
//    init(prefix:String, content:String, suffix:String) {
//        self = .container((prefix: prefix, content: .content(content), suffix: suffix))
//    }
//
//    init(prefix:String, content:StringNode, suffix:String) {
//        self = .container((prefix: prefix, content: content, suffix: suffix))
//    }
//
//    private static func stringify(node:StringNode) -> String {
//        switch node {
//        case .content(let s):
//            return s
//        case .container(let tuple):
//            let prefix = tuple.prefix
//            let suffix = tuple.suffix
//            let content = stringify(node: tuple.content)
//            return "\(prefix)\(content)\(suffix)"
//        }
//    }
//
//    func makeString() -> String {
//        Self.stringify(node: self)
//    }
//}
//
//@resultBuilder
//struct StringNodeBuilder {
//
//    static func buildBlock(_ components: [StringNode]...) -> [StringNode] {
//        buildArray(components)
//    }
//
//    public static func buildArray(_ components: [[StringNode]]) -> [StringNode] {
//        return components.flatMap { $0 }
//    }
//}
//
//
//public struct Indent: BuilderStringConvertible {
//    let count:Int
//    let indentString:String
//    public init(count:Int, indentString:String = "\t") {
//        self.count = count
//        self.indentString = indentString
//    }
//    public func makeStringForBuilder() -> String {
//        var tmp = ""
//        for _ in 0..<count {
//            tmp.append(indentString)
//        }
//        return tmp
//    }
//}
//
//
//
//// Just compose a string Easy Peasy
//
//protocol BuilderStringConvertible {
//    func makeStringForBuilder() -> String
//}
//
//extension String: BuilderStringConvertible {
//    public func makeStringForBuilder() -> String {
//        self
//    }
//}
//
//public struct LineBreak: BuilderStringConvertible {
//    public init() { }
//    public func makeStringForBuilder() -> String {
//        "\n"
//    }
//}
//
//public struct Space: BuilderStringConvertible {
//    public init() { }
//    public func makeStringForBuilder() -> String {
//        " "
//    }
//}
//
//
//@resultBuilder
//struct StringBuilder {
//    static func buildBlock(_ parts: String...) -> String {
//        buildArray(parts)
//    }
//
//
//    static func buildOptional(_ component:String?) -> String {
//        component ?? ""
//    }
//
//    static func buildEither(first component: String) -> String {
//        return component
//    }
//
//    static func buildEither(second component: String) -> String {
//        return component
//    }
//
//    static func buildArray(_ components: [String]) -> String {
//        components.joined()
//    }
//
//    //     static func buildFinalResult(_ component: String) -> Data? {
//    //         component.data(using: .utf8)
//    //     }
//}
