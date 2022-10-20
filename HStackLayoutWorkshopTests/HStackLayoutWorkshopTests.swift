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
    
    func testHStackWhereChildrenHaveFlexibleConstrainedFrames() {
        testHStackLayout(width: 150, spacing: 0) {
            Color.red
                .frame(maxWidth: 100)
            Color.green
                .frame(minWidth: 100)
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
    
    func testHStackLayout(width: CGFloat = 300, height: CGFloat = 100, spacing: CGFloat?, @ViewBuilder content: () -> some View, line: UInt = #line) {
        testHStackLayoutUsingProxy(width: width, height: height, spacing: spacing, content: content(), line: line)
        testHStackLayoutUsingSnapshot(width: width, height: height, spacing: spacing, content: content(), line: line)
    }
    
    func testHStackLayoutUsingProxy(width: CGFloat, height: CGFloat, spacing: CGFloat?, content: some View, line: UInt) {
        
        let ref = ChildrenFrameProxy()
        let sut = ChildrenFrameProxy()
        
        render(width: width, height: height) {
            ChildrenFrameReader(layout: HStackLayout(spacing: spacing), proxy: ref) {
                content
            }
        }

        render(width: width, height: height) {
            ChildrenFrameReader(layout: MyHStackLayout(spacing: spacing), proxy: sut) {
                content
            }
        }

        for id in ref.ids {
            assert(id: id, sut: sut, ref: ref, keyPath: \.origin.x, name: "origin.x", line: line)
            assert(id: id, sut: sut, ref: ref, keyPath: \.origin.y, name: "origin.y", line: line)
            assert(id: id, sut: sut, ref: ref, keyPath: \.size.width, name: "size.width", line: line)
            assert(id: id, sut: sut, ref: ref, keyPath: \.size.height, name: "size.height", line: line)
        }
        
    }
    
    func testHStackLayoutUsingSnapshot(width: CGFloat, height: CGFloat, spacing: CGFloat?, content: some View, line: UInt) {

        let ref = makeController(width: width, height: height, for: content, layout: HStackLayout(spacing: spacing))
        let sut = makeController(width: width, height: height, for: content, layout: MyHStackLayout(spacing: spacing))
        
        let _ = verifySnapshot(matching: ref.view, as: .image, named: "content", record: true)
        
        assertSnapshot(matching: sut.view, as: .image, named: "content", line: line)
        
    }
    
    func assert(id: AnyHashable, sut: ChildrenFrameProxy, ref: ChildrenFrameProxy, keyPath: KeyPath<CGRect, CGFloat>, name: String, line: UInt) {
        let sut = sut[id]![keyPath: keyPath]
        let ref = ref[id]![keyPath: keyPath]
        let message = "\n \(id) : \(name) - diff: \(sut - ref)"
        XCTAssertEqual(sut, ref, message, line: line)
    }
    
    func makeController(width: CGFloat, height: CGFloat, for content: some View, layout: some Layout) -> UIViewController {
        UIHostingController(rootView: layout({ content }).frame(width: width, height: height))
    }
    
    func render(width: CGFloat, height: CGFloat, @ViewBuilder content: () -> some View) {
        let controller = UIHostingController(rootView: content().frame(width: width, height: height))
        let window = UIWindow(frame: .zero)
        window.rootViewController = controller
        window.makeKeyAndVisible()
        window.layoutIfNeeded()
    }
    
}
