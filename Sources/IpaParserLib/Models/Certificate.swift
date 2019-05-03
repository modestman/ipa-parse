//
//  Certificate.swift
//  IpaParserLib
//
//  Created by Anton Glezman on 03/05/2019.
//

import Foundation

public struct Certificate: Codable {
    
    let summary: String
    var organizationName: String?
    var expirationDate: Date?
    
    public init(summary: String) {
        self.summary = summary
    }
    
}
