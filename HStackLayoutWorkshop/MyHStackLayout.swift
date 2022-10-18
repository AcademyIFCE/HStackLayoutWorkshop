import SwiftUI

struct MyHStackLayout: Layout {
    
    struct Cache { }

    var spacing: CGFloat? = nil

    func makeCache(subviews: Subviews) -> Cache {
        return Cache()
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        fatalError("\(#function) not implemented")
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        fatalError("\(#function) not implemented")
    }
    
}
