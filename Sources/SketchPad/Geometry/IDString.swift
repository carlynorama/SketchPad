//
//  File.swift
//  
//
//  Created by Labtanza on 8/3/23.
//

import Foundation

//TODO: Not guaranteed to be unique. This causes trouble.
enum IdString {
    static func make(prefix:String) -> String {
        "\(prefix)_\(Int.random(in: 10000..<100000))"
    }
    // let value:String
    
    // init(prefix:String) {
    //     self.value = "\(prefix)_\(Int.random(in: 10000..<100000))"
    // }
}
