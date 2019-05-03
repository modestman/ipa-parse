//
//  InfoPlist.swift
//  IpaParserLib
//
//  Created by Anton Glezman on 02/05/2019.
//

import Foundation

public enum DeviceFamily: Int, CustomStringConvertible {
    case iPhone = 1
    case iPad = 2
    
    public var description: String {
        switch self {
        case .iPhone:
            return "iPhone"
        case .iPad:
            return "iPad"
        }
    }
}

public struct InfoPlist: Codable {
    
    let bundleId: String
    let displayName: String
    let version: String
    let build: String
    let minimumOSVersion: String?
    let devices: [String]
    
}


extension InfoPlist {
    
    static func make(propertyList: [AnyHashable : Any]) -> InfoPlist? {
        guard
            let bundleId = propertyList["CFBundleIdentifier"] as? String,
            let displayName = propertyList["CFBundleDisplayName"] as? String,
            let version = propertyList["CFBundleShortVersionString"] as? String,
            let build = propertyList["CFBundleVersion"] as? String
            else {
                return nil
        }
        let osVersion = propertyList["MinimumOSVersion"] as? String
        
        var devices =  [String]()
        if let deviceFamily = propertyList["UIDeviceFamily"] as? [Int] {
            devices = deviceFamily.compactMap { DeviceFamily(rawValue: $0)?.description }
        }
        
        return InfoPlist(
            bundleId: bundleId,
            displayName: displayName,
            version: version,
            build: build,
            minimumOSVersion: osVersion,
            devices: devices)
    }
    
}
