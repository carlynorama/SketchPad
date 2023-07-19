//
//  File.swift
//  
//
//  Created by Carlyn Maw on 7/17/23.
//

import Foundation

extension String {
    func embrace(with e:String, maintainOrder:Bool = false) -> String {
        if e.count <= 1 || maintainOrder {
            return "\(e)\(self)\(e)"
        } else  {
            return "\(e)\(self)\(String(e.reversed()))"
        }
    }
    func quoted()  -> String{
        embrace(with:"\"")
    }
}

