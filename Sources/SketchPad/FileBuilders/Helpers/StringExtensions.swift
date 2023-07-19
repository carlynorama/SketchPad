//
//  File.swift
//  
//
//  Created by Carlyn Maw on 7/17/23.
//

import Foundation

extension String {
    func embrace(with e:String) -> String {
        "\(e)\(self)\(e)"
    }
    func quoted()  -> String{
        embrace(with:"\"")
    }
}

