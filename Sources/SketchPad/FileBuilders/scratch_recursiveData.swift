//See Advent of Code 2022 Day 13

// enum Packet: Comparable, Decodable {
//         case num(Int), list([Packet])
        
//         public init(from decoder: Decoder) throws {
//             do {
//                 let c = try decoder.singleValueContainer()
//                 self = .num(try c.decode(Int.self))
//             } catch {
//                 self = .list(try [Packet](from: decoder))
//             }
//         }
        
//         public static func < (lhs: Self, rhs: Self) -> Bool {
//             switch (lhs, rhs) {
//             case (.num(let lValue), .num(let rValue)): return lValue < rValue
//             case (.num(_), .list(_)): return .list([lhs]) < rhs
//             case (.list(_), .num(_)): return lhs < .list([rhs])
//             case (.list(let lValue), .list(let rValue)):
//                 for (l, r) in zip(lValue, rValue) {
//                     if l < r { return true }
//                     if l > r { return false }
//                 }
//                 return lValue.count < rValue.count
//             }
//         }
//     }
    
//     //https://developer.apple.com/documentation/swift/expressiblebyarrayliteral
//     //https://developer.apple.com/documentation/swift/expressiblebyintegerliteral
//     //idirect = recursive enumerations: https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html
//     //https://www.hackingwithswift.com/example-code/language/what-are-indirect-enums
//     enum Message: ExpressibleByIntegerLiteral, ExpressibleByArrayLiteral, Comparable {
//         case value(Int)
//         indirect case list([Message])

//         init(integerLiteral: Int) {
//             self = .value(integerLiteral)
//         }
        
//         //for compliance with expressible by arrayliteral
//         init(arrayLiteral: Self...) {
//             self = .list(arrayLiteral)
//         }

//         static func < (lhs: Self, rhs: Self) -> Bool {
//             switch (lhs, rhs) {
//             case (.value(let l), .value(let r)): return l < r
//             case (.value(_), .list(_)): return .list([lhs]) < rhs
//             case (.list(_), .value(_)): return lhs < .list([rhs])
//             case (.list(let l), .list(let r)):
//                 for (le, re) in zip(l, r) {
//                     if le < re { return true }
//                     if le > re { return false }
//                 }
//                 return l.count < r.count
//             }
//         }
//     }

// [
// [
// 0,
// []],
// [],
// [
// [
// [1,9,1],7],
// [8],
// [[9]],
// [[10,9,10,1],
// [0,0,8,0,1],
// [10,4,5,6,9],
// [6,6,5],5]]]




// [
// [
// [
// [8,7,8,9,10],
// [5,1,8,5]],
// [3,3]]]