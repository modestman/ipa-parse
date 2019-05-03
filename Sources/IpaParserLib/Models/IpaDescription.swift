//
//  IpaDescription.swift
//  ipa-parse
//
//  Created by Anton Glezman on 25/04/2019.
//

import Foundation


public struct IpaDescription: Codable {
    
    let uuid: String
    let date: Date
    let fileName: String
    let size: UInt64
    var infoPlist: InfoPlist?
    var provisioningProfile: Provisioning?
    var icon: Base64File?
    
    public init(fileName: String, size: UInt64) {
        self.uuid = UUID().uuidString
        self.date = Date()
        self.fileName = fileName
        self.size = size
    }
}
