import XCTest
import SwiftUI
import SnapshotTesting
@testable import HStackLayoutWorkshop

final class HStackLayoutFromScratchTests: XCTestCase {
    
    override class func setUp() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    func testHStackWithoutSpacing() {
        testHStackLayout(spacing: 0) {
            Color.red
            Color.green
            Color.blue
        }
    }
    
    func testHStackWithDefaultSpacing() {
        testHStackLayout(spacing: nil) {
            Color.red
            Color.green
            Color.blue
        }
    }
    
    func testHStackWithExplicitSpacing() {
        testHStackLayout(spacing: 10) {
            Color.red
            Color.green
            Color.blue
        }
    }
    
    func testHStackWhereFirstChildHasFixedWidth() {
        testHStackLayout(width: 150, spacing: 0) {
            Color.red
                .frame(width: 100)
            Color.green
        }
    }
    
    func testHStackWhereSecondChildHasFixedFrame() {
        testHStackLayout(width: 150, spacing: 0) {
            Color.red
            Color.green
                .frame(width: 100)
        }
    }
    
    func testHStackWhereChildrenHaveEqualFlexibilityButOneHasHigherPriority() {
        testHStackLayout(width: 150, spacing: 0) {
            Color.red
                .frame(maxWidth: 100)
                .layoutPriority(1)
            Color.green
                .frame(maxWidth: 100)
        }
    }
    
    func testHStackLayout(width: CGFloat = 300, height: CGFloat = 100, spacing: CGFloat?, @ViewBuilder content: () -> some View, file: StaticString = #file, line: UInt = #line, function: String = #function) {
        testHStackLayoutUsingProxy(width: width, height: height, spacing: spacing, content: content(), file: file, line: line)
        testHStackLayoutUsingSnapshot(width: width, height: height, spacing: spacing, content: content(), file: file, line: line, function: function)
    }
    
}
