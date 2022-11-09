import XCTest
import SwiftUI
import SnapshotTesting
@testable import HStackLayoutWorkshop

// MARK: Proxy

func testHStackLayoutUsingProxy(width: CGFloat, height: CGFloat, spacing: CGFloat?, content: some View, file: StaticString, line: UInt) {
    
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
        assert(id: id, sut: sut, ref: ref, keyPath: \.origin.x, name: "origin.x", file: file, line: line)
        assert(id: id, sut: sut, ref: ref, keyPath: \.origin.y, name: "origin.y", file: file, line: line)
        assert(id: id, sut: sut, ref: ref, keyPath: \.size.width, name: "size.width", file: file, line: line)
        assert(id: id, sut: sut, ref: ref, keyPath: \.size.height, name: "size.height", file: file, line: line)
    }
    
}

func render(width: CGFloat, height: CGFloat, @ViewBuilder content: () -> some View) {
    let controller = UIHostingController(rootView: content().frame(width: width, height: height))
    let window = UIWindow(frame: .zero)
    window.rootViewController = controller
    window.makeKeyAndVisible()
    window.layoutIfNeeded()
}

func assert(id: AnyHashable, sut: ChildrenFrameProxy, ref: ChildrenFrameProxy, keyPath: KeyPath<CGRect, CGFloat>, name: String, file: StaticString, line: UInt) {
    let sut = sut[id]![keyPath: keyPath]
    let ref = ref[id]![keyPath: keyPath]
    let message = "\n \(id) : \(name) - diff: \(sut - ref)"
    XCTAssertEqual(sut, ref, accuracy: 0.25, message, file: file, line: line)
}

// MARK: Snapshot

func testHStackLayoutUsingSnapshot(width: CGFloat, height: CGFloat, spacing: CGFloat?, content: some View, file: StaticString, line: UInt, function: String = #function) {

    let ref = makeController(width: width, height: height, for: content, layout: HStackLayout(spacing: spacing))
    let sut = makeController(width: width, height: height, for: content, layout: MyHStackLayout(spacing: spacing))
    
    let _ = verifySnapshot(matching: ref.view, as: .image, named: "content", record: true, file: file, testName: function, line: line)

    assertSnapshot(matching: sut.view, as: .image, named: "content", file: file, testName: function, line: line)
    
}

func makeController(width: CGFloat, height: CGFloat, for content: some View, layout: some Layout) -> UIViewController {
    UIHostingController(rootView: layout({ content }).frame(width: width, height: height))
}
