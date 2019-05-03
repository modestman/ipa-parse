//
//  IpaParser.swift
//  ipa-parseTests
//
//  Created by Anton Glezman on 01/05/2019.
//

import XCTest
@testable import IpaParserLib

class IpaParserTests: XCTestCase {

    func testMainIconName() throws {
        let parser = IpaParser()
        let icon = parser.mainIconNameForApp(propertyList: IpaInfoPlist.appPropertyList)
        XCTAssertEqual(icon, "AppIcon60x60")
    }

    static var allTests = [
        ("testMainIconName", testMainIconName)
    ]
}
