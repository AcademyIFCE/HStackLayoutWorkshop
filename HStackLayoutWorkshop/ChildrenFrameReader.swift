import SwiftUI

struct FramePreferenceKey: PreferenceKey {
    
    static func reduce(value: inout [AnyHashable : CGRect], nextValue: () -> [AnyHashable : CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
    
    static var defaultValue: [AnyHashable: CGRect] = [:]
    
}

class ChildrenFrameProxy: ObservableObject {
    
    @Published var frames = [AnyHashable : CGRect]()
    
    var ids: [AnyHashable] { Array(frames.keys).sorted(using: KeyPathComparator(\.debugDescription, order: .forward)) }
    
    subscript(id: AnyHashable) -> CGRect? {
        return frames[id]
    }
    
}

struct ChildrenFrameReader<L: Layout, Content: View>: View {
    
    let layout: L
    
    @ObservedObject var proxy: ChildrenFrameProxy
    @ViewBuilder var content: Content
    
    var body: some View {
        _VariadicView.Tree(Root(layout: layout)) {
            content
        }
        .onPreferenceChange(FramePreferenceKey.self) {
            proxy.frames = $0
        }
    }
    
    struct Root: _VariadicView_UnaryViewRoot {
        
        let layout: L
        
        @ViewBuilder
        func body(children: _VariadicView.Children) -> some View {
            layout {
                ForEach(children) { child in
                    child
                        .overlay {
                            GeometryReader { proxy in
                                let frame = proxy.frame(in: .named("layout"))
                                Color.clear
                                    .preference(key: FramePreferenceKey.self, value: [child.id: frame])
                            }
                        }
                }
            }
            .coordinateSpace(name: "layout")
        }
        
    }
    
}
