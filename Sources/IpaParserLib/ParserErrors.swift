//
//  ParserErrors.swift
//  IpaParserLib
//
//  Created by Anton Glezman on 01/05/2019.
//

import Foundation

public enum ParserErrors: Error {
    
    case fileNotExists
    case fileNotIpa
    case cantParseInfoPlist
    
    public var localizedDescription: String {
        switch self {
        case .fileNotExists:
            return ".ipa file not found"
        case .fileNotIpa:
            return "File type is not '.ipa'"
        case .cantParseInfoPlist:
            return "Can't parse Info.plist"
        }
    }
}
