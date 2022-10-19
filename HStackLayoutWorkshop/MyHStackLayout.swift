import SwiftUI

struct MyHStackLayout: Layout {
    
    struct Cache { }

    var spacing: CGFloat? = nil

    func makeCache(subviews: Subviews) -> Cache {
        return Cache()
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        
        let proposedHeight = proposal.replacingUnspecifiedDimensions().height
        let proposedWidth = proposal.replacingUnspecifiedDimensions().width/CGFloat(subviews.count)
        
        let proposedSize = ProposedViewSize(width: proposedWidth, height: proposedHeight)
        
        var sizes: [CGSize] = []
        
        for subview in subviews {
            let size = subview.sizeThatFits(proposedSize)
            sizes.append(size)
        }
        
        let widthThatFits = sizes.reduce(0) { $0 + $1.width }
        let heightThatFits = sizes.reduce(0) { max($0, $1.height) }
        
        return CGSize(width: widthThatFits, height: heightThatFits)
        
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        
        var position = CGPoint(x: bounds.minX, y: bounds.midY)
        
        let proposedHeight = proposal.replacingUnspecifiedDimensions().height
        let proposedWidth = proposal.replacingUnspecifiedDimensions().width/CGFloat(subviews.count)
        
        let proposedSize = ProposedViewSize(width: proposedWidth, height: proposedHeight)
        
        for subview in subviews {
            let size = subview.sizeThatFits(proposedSize)
            subview.place(at: position, anchor: .leading, proposal: proposedSize)
            position.x += size.width
        }
        
    }
    
}
