public struct Indent {
    let count:Int
    let indentString:String
    let prefix:String
    public init(count:Int, indentString:String = "\t", prefix:String="") {
        self.count = count
        self.indentString = indentString
        self.prefix = prefix
    }
    
    var value:String {
        var tmp = ""
        for _ in 0..<count {
            tmp.append(indentString)
        }
        return "\(prefix)\(tmp)"
    }
}


indirect enum StringNode {

    
    
    case content(String)
    case container((prefix:String, content:StringNode, suffix:String))
    case list([StringNode])
    
    init(_ string:String) {
        self = .content(string)
    }
    
    init(prefix:String, content:String, suffix:String) {
        self = .container((prefix: prefix, content: .content(content), suffix: suffix))
    }
    
    init(prefix:String, content:StringNode, suffix:String) {
        self = .container((prefix: prefix, content: content, suffix: suffix))
    }
    
    init(_ content:StringNode...) {
        self = .list(content)
    }
    
    public init(@StringNodeBuilder content: () -> [StringNode]) {
        self = .list(content())
    }
    
    //TODO: Why didn't this work as expected?
    //    public init(prefix:String, suffix:String,
    //                @StringNodeBuilder content: () -> StringNode) {
    //        self = .container((prefix: prefix,
    //                           content: content(),
    //                           suffix: suffix))
    //    }
    
    static func stringify(node:StringNode) -> String {
        switch node {
        case .content(let s):
            return s
        case .container(let tuple):
            let prefix = tuple.prefix
            let suffix = tuple.suffix
            let content = stringify(node: tuple.content)
            return "\(prefix)\(content)\(suffix)"
        case .list(let nodeArray):
            return Self.stringify(nodeSet: nodeArray)
        }
    }
    
    static func stringify(nodeSet:[StringNode]) -> String {
        nodeSet.map({ $0.makeString() }).joined()
    }
    
    func makeString() -> String {
        Self.stringify(node: self)
    }
    
    private static func indentStringify(node: StringNode, level:Int = 0) -> String {
        let indent = Indent(count: level, prefix: "")
        let ind = indent.value
        
        switch node {
        case .content(let s):
            return "\(ind)\(s)"
        case .container(let tuple):
            let prefix = tuple.prefix
            let suffix = tuple.suffix
            let content = indentStringify(node: tuple.content, level: level + 1)
            return "\(ind)\(prefix)\("\n")\(content)\("\n")\(ind)\(suffix)"
        case .list(let nodeArray):
            return indentStringify(nodeSet:nodeArray, startLevel:level, separator:"\n")
        }
    }
    static func indentStringify(nodeSet:[StringNode],
                                startLevel:Int = 0,
                                separator:String="") -> String {
        nodeSet.map({
            $0.indentedString(startLevel: startLevel)
        }).joined(separator: separator)
    }
    
    func indentedString(startLevel:Int = 0) -> String {
        Self.indentStringify(node: self, level: startLevel)
    }
}

extension StringNode: Equatable {
    static func == (lhs: StringNode, rhs: StringNode) -> Bool {
        switch (lhs, rhs) {
        case (.container(let lhs), .container(let rhs)):
            return lhs == rhs
        case (.content(let lhs), .content(let rhs)):
            return lhs == rhs
        case (.list(let lhs), .list(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}

@resultBuilder
enum StringNodeBuilder {
    static func buildBlock(_ components: [StringNode]...) -> [StringNode] {
        buildArray(components)
    }
    
    public static func buildExpression(_ expression: StringNode) -> [StringNode] {
        [expression]
    }
    
    public static func buildArray(_ components: [[StringNode]]) -> [StringNode] {
        return components.flatMap { $0 }
    }
    
    static func buildOptional(_ component:[StringNode]?) -> [StringNode] {
        component ?? []
    }
    
    //Commented out b/c replaced with StringNodeable
    //    public static func buildExpression(_ expression: String) -> [StringNode] {
    //        [.content(expression)]
    //    }
    //
    //    static func buildExpression(_ components: String...) -> [StringNode] {
    //        components.compactMap { .content($0) }
    //    }
    //
    //    static func buildExpression(_ components: [String]...) -> [StringNode] {
    //        components.flatMap { $0 }.compactMap { .content($0) }
    //    }
    
    public static func buildExpression(_ expression: StringNodeable) -> [StringNode] {
        [expression.asStringNode]
    }
    
    static func buildExpression(_ components: StringNodeable...) -> [StringNode] {
        components.compactMap { $0.asStringNode }
    }
    
    static func buildExpression(_ components: [StringNodeable]...) -> [StringNode] {
        components.flatMap { $0 }.compactMap { $0.asStringNode }
    }
}
protocol StringNodeable {
    var asStringNode:StringNode { get }
}

extension String:StringNodeable {
    var asStringNode: StringNode {
        .content(self)
    }
}
