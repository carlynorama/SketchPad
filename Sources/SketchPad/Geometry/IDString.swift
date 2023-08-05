//
//  IDString.swift
//  
//
//  Created by Carlyn Maw on 8/3/23.
//

import Foundation

//TODO: Not guaranteed to be unique. This causes trouble.
//Why this? Experienced UUIDs as being too long. 
enum IdString {
    static func make(prefix:String) -> String {
        "\(prefix)_\(Int.random(in: 10000..<100000))"
    }
    // let value:String
    
    // init(prefix:String) {
    //     self.value = "\(prefix)_\(Int.random(in: 10000..<100000))"
    // }
}
