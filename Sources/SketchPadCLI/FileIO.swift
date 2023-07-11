//
//  FileIO.swift
//  
//
//  Created by Carlyn Maw on 4/19/23.
//

// TODO: Pulled in from clipng. Clean up, check against new foundation,


//#if os(Linux)
//import Glibc
//#else
//import Darwin.C
//
//#endif

import Foundation


enum FileIO {
   
    static func timeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd'T'HHmmss"
        return formatter.string(from: Date()) //<- TODO: confirm that is "now"
        
    }
    
//    func timeStampForFile() -> String {
//        //Date.now.ISO8601Format()
//        let date = Date.now
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMdd'T'HHmmss"
//        return formatter.string(from: date)
//    }
    
    static func makeFileURL(filePath:String) -> URL {
        //TODO: For iOS??
        //let locationToWrite = URL.documentsDirectory.appendingPathComponent("testImage", conformingTo: .png)
        #if os(Linux)
        return URL(fileURLWithPath: filePath)
        #else
        if #available(macOS 13.0, *) {
            return URL(filePath: filePath)
        } else {
            // Fallback on earlier versions
             return URL(fileURLWithPath: filePath)
        }
        #endif
    }
    
    
    static func writeDataToFile(data:Data , filePath:String) throws {
        let url = makeFileURL(filePath: filePath)
        try data.write(to: url)
    }
    
    //---------
    //https://www.swiftbysundell.com/articles/working-with-files-and-folders-in-swift/
    //FileManager.default.temporaryDirectory, .cachesDirectory
    
    
    static func write<T: Encodable>(
        _ value: T,
        toDocumentNamed documentName: String,
        encodedUsing encoder: JSONEncoder = .init()
    ) throws {
        let folderURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )

        let fileURL = folderURL.appendingPathComponent(documentName)
        let data = try encoder.encode(value)
        try data.write(to: fileURL)
    }
    
#if !os(Linux)
    //TODO: What happens when folders in a path don't exist with writeDataToFile
    @available(macOS 13.0, *)
    static func write<T: Encodable>(
        _ value: T,
        toDocumentNamed documentName: String,
        inFolder folderName: String,
        encodedUsing encoder: JSONEncoder = .init()
    ) throws {
        let folderURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appending(component: folderName) //not available linux use older .appendingPathComponent
        
        if !FileManager.default.fileExists(atPath: folderURL.relativePath) {
            try FileManager.default.createDirectory(
                at: folderURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
        }

        let fileURL = folderURL.appendingPathComponent(documentName)
        let data = try encoder.encode(value)
        try data.write(to: fileURL)
    }
    #endif
    
}
