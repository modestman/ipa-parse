//
//  Provisioning.swift
//  IpaParserLib
//
//  Created by Anton Glezman on 02/05/2019.
//

import Foundation

public struct Provisioning: Codable {
    
    let name: String
    let appIDName: String
    let teamIdentifier: [String]
    let profileType: String
    let creationDate: Date
    let expirationDate: Date
    var developerCertificates: [Certificate] = []
    
    init(mobileProvosion: MobileProvision) {
        name = mobileProvosion.name
        appIDName = mobileProvosion.appIDName
        profileType = mobileProvosion.profileType
        teamIdentifier = mobileProvosion.teamIdentifier
        creationDate = mobileProvosion.creationDate
        expirationDate = mobileProvosion.expirationDate
    }
    
}
