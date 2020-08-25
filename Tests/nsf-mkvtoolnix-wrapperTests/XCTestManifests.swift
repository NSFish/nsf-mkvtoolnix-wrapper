import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(nsf_mkvtoolnix_wrapperTests.allTests),
    ]
}
#endif
