//
//  Base64File.swift
//  IpaParserLib
//
//  Created by Anton Glezman on 02/05/2019.
//

import Foundation

public struct Base64File: Codable {
    
    let base64Data: String
    let type: String
    let name: String
    
    var data: Data? {
        return Data(base64Encoded: base64Data)
    }
    
    public init(data: Data, name: String, type: String) {
        self.base64Data = data.base64EncodedString()
        self.name = name
        self.type = type
    }
    
}
