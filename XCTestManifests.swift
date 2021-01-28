import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(ion_sdk_swiftTests.allTests),
        ]
    }
#endif
