import XCTest

import ipa_parseTests

var tests = [XCTestCaseEntry]()
tests += ipa_parseTests.allTests()
XCTMain(tests)
