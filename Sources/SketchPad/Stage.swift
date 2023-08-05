//
//  Stage.swift
//  
//
//  Created by Carlyn Maw on 8/5/23.
//

import Foundation

//public struct Stage:Layer {
//    var body:any Layer
//    public init(@LayerBuilder body: () -> some Layer) {
//        self.body = body()
//    }
//
//
//}

struct Stage<Body:Layer>:Layer {
    var body: Body
    public init(@LayerBuilder body: () -> Body) {
        self.body = body()
    }
}
