struct Document {
    enum RenderStyle {
        case minimal
        case indented
    }
    
    let content:[StringNode]
    init(@StringNodeBuilder content: () -> [StringNode]) {
        self.content = content()
    }
    
    func render(style: RenderStyle = .indented) -> String {
        switch style {
        case .indented:
            return StringNode.indentStringify(nodeSet: content, separator:"\n")
        case .minimal:
            return StringNode.stringify(nodeSet: content)
        }
    }
}

enum BraceStyle {
    case compact, semiCompact, expanded
}

protocol Bracing:StringNodeable {
    var braceOpener:String { get }
    var braceCloser:String { get }
    var precedingText:String? { get set }
    var content: StringNode { get set }
    var style:BraceStyle { get set }
    var asStringNode: StringNode { get }
} 

extension Bracing {
    var asStringNode: StringNode {
        switch style {
        case .expanded:
            guard let precedingText else {
                fallthrough
            }
            return .list([
                .content(precedingText),
                .container((prefix: braceOpener, content: content, suffix: braceCloser))
            ])
        case .semiCompact:
            let start = precedingText != nil ? "\(precedingText!) \(braceOpener)" : "\(braceOpener)"
            return .container((prefix: start, content: content, suffix: braceCloser))
        case .compact:
            let contentString = StringNode.stringify(node:content)
            return .content("\(precedingText ?? "")\(braceOpener)\(contentString)\(braceCloser)")
        }
    }
}

struct CurlyBraced:Bracing {
    let braceOpener:String = "{"
    let braceCloser:String = "}"
    
    var precedingText: String?
    var style: BraceStyle
    var content: StringNode
    
    //TODO: Try again to put this as part of the protocol? A Macro?
    init(opening:String? = nil, style:BraceStyle = .semiCompact, @StringNodeBuilder content: () -> [StringNode]) {
        self.precedingText = opening
        //TODO: What if content is empty or only 1 item?
        self.content = .list(content())
        self.style = style
    }
}

struct Parens:Bracing {
    let braceOpener:String = "("
    let braceCloser:String = ")"
    
    var precedingText: String?
    var style: BraceStyle
    var content: StringNode
    
    //TODO: Try again to put this as part of the protocol? A Macro?
    init(opening:String? = nil, style:BraceStyle = .semiCompact, @StringNodeBuilder content: () -> [StringNode]) {
        self.precedingText = opening
        //TODO: What if content is empty or only 1 item?
        self.content = .list(content())
        self.style = style
    }
}

struct Tag:StringNodeable {
    
    let name:String
    let attributes:Dictionary<String, String>?
    
    var prefix: String { 
        if let attributes {
            //TODO Make this a choice? Define Tag as being an XML tag?
            return "<\(name)\(Self.attributesFromDictionaryXML(attributes))>"
        } else {
            return "<\(name)>" 
        }
        
    }
    var suffix: String { "</\(name)>" }
    
    var content: StringNode
    
    init(_ name:String, attributes:Dictionary<String, String>? = nil, @StringNodeBuilder content: () -> [StringNode]) {
        self.name = name
        self.attributes = attributes
        self.content = .list(content())
    }
    
    var asStringNode: StringNode {
        .container((prefix: prefix, content: content, suffix: suffix))
    }
    
}

extension Tag {
    static func attributesFromDictionaryHTML(_ dict:Dictionary<String, String>) -> String {
        var tmp:String = ""
        for (key, value) in dict {
            tmp.append(" \(key.quoted())=\(value.quoted())")
        }
        return tmp
    }
    static func attributesFromDictionaryXML(_ dict:Dictionary<String, String>) -> String {
        var tmp:String = ""
        for (key, value) in dict {
            tmp.append(" \(key)=\(value.embrace(with: "'"))")
        }
        return tmp
    }
}

