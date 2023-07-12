
import Foundation

struct USDAFileBuilder {
    var stage:Canvas3D
    var defaultPrimIndex:Int
    let metersPerUnit:Int
    let upAxis:String
    let documentationNote:String?
    
    public init(stage: Canvas3D, defaultPrimIndex: Int = 0, metersPerUnit: Int = 1, upAxis: String = "Y", docNote:String? = nil) {
        self.stage = stage
        self.defaultPrimIndex = defaultPrimIndex
        self.metersPerUnit = metersPerUnit
        self.upAxis = upAxis
        self.documentationNote = docNote
    }
    
    @StringBuilder func generateHeader() -> String {
        "#usda 1.0\n("
        "\tdefaultPrim = \"\(stage.content[defaultPrimIndex].id)\""
        "\tmetersPerUnit = \(metersPerUnit)"
        "\tupAxis = \"\(upAxis)\""
        if let documentationNote {
            "doc = \"\(documentationNote)\""
        }
        ")"
    }
   
    func translateString(_ xoffset:Double, _ yoffset:Double, _ zoffset:Double) -> String {
        return "\tdouble3 xformOp:translate = (\(xoffset), \(yoffset), \(zoffset))"
    }

    func opOrderStringTranslateOnly() -> String {
        "\tuniform token[] xformOpOrder = [\"xformOp:translate\"]"
    }
        
    func colorString(_ red:Double, _ green:Double, _ blue:Double) -> String {
        "\t\tcolor3f[] primvars:displayColor = [(\(red), \(green), \(blue))]"
    }
        
    func  radiusString(_ radius:Double) -> String {
         "\t\tdouble radius = \(radius)"
    }

    @StringBuilder func  buildPrimitive(geometry:Geometry) -> String {
        """
        \nover "\(id)" (\n\tprepend references = @./\(reference_file).usd@\n)\n{
        """
        
        if xoffset != 0 || yoffset != 0 || zoffset != 0 {
            translateString(xoffset, yoffset, zoffset)
            opOrderStringTranslateOnly()
        }
                   
        """
        \tover "\(geometry_name)"\n\t{
        """
        colorString(red, green, blue)
        radiusString(radius)
        "\t}"
        "}"
    }


     
    }

