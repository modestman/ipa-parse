//
//  MobileProvision.swift
//  IpaParserLib
//
//  Created by Anton Glezman on 02/05/2019.
//

import Foundation

struct MobileProvision: Decodable {
    var name: String
    var appIDName: String
    var teamIdentifier: [String]
    var platform: [String]
    var isXcodeManaged: Bool? = false
    var creationDate: Date
    var expirationDate: Date
    var entitlements: Entitlements
    var developerCertificates: [Data]
    var provisionedDevices: [String]
    var provisionsAllDevices: Bool?
    
    private enum CodingKeys : String, CodingKey {
        case name = "Name"
        case appIDName = "AppIDName"
        case teamIdentifier = "TeamIdentifier"
        case platform = "Platform"
        case isXcodeManaged = "IsXcodeManaged"
        case creationDate = "CreationDate"
        case expirationDate = "ExpirationDate"
        case entitlements = "Entitlements"
        case developerCertificates = "DeveloperCertificates"
        case provisionedDevices = "ProvisionedDevices"
        case provisionsAllDevices = "ProvisionsAllDevices"
    }
    
    var profileType: String {
        let type: String
        if !provisionedDevices.isEmpty {
            if entitlements.getTaskAllow {
                type = "Development"
            } else {
                type = "Distribution (Ad Hoc)"
            }
        } else {
            if provisionsAllDevices == true {
                type = "Enterprise"
            } else {
                type = "Distribution (App Store)"
            }
        }
        return "iOS \(type)"
    }
    
    
    struct Entitlements: Decodable {
        let applicationIdentifier: String
        let keychainAccessGroups: [String]
        let getTaskAllow: Bool
        let apsEnvironment: Environment
        
        private enum CodingKeys: String, CodingKey {
            case applicationIdentifier = "application-identifier"
            case keychainAccessGroups = "keychain-access-groups"
            case getTaskAllow = "get-task-allow"
            case apsEnvironment = "aps-environment"
        }
        
        enum Environment: String, Decodable {
            case development, production, disabled
        }
        
        init(
            applicationIdentifier: String,
            keychainAccessGroups: Array<String>,
            getTaskAllow: Bool,
            apsEnvironment: Environment) {
            self.applicationIdentifier = applicationIdentifier
            self.keychainAccessGroups = keychainAccessGroups
            self.getTaskAllow = getTaskAllow
            self.apsEnvironment = apsEnvironment
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let applicationIdentifier: String = (try? container.decode(String.self, forKey: .applicationIdentifier)) ?? ""
            let keychainAccessGroups: [String] = (try? container.decode([String].self, forKey: .keychainAccessGroups)) ?? []
            let getTaskAllow: Bool = (try? container.decode(Bool.self, forKey: .getTaskAllow)) ?? false
            let apsEnvironment: Environment = (try? container.decode(Environment.self, forKey: .apsEnvironment)) ?? .disabled
            
            self.init(
                applicationIdentifier: applicationIdentifier,
                keychainAccessGroups: keychainAccessGroups,
                getTaskAllow: getTaskAllow,
                apsEnvironment: apsEnvironment)
        }
    }
}



