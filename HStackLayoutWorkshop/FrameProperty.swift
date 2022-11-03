import Foundation

struct FrameProperty: Identifiable {
    let id: String
    let keyPath: KeyPath<CGRect, CGFloat>
}
