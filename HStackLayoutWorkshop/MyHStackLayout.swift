import SwiftUI

struct MyHStackLayout: Layout {
    
    struct Cache { }

    var spacing: CGFloat? = nil

    func makeCache(subviews: Subviews) -> Cache {
        return Cache()
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        
        let fullWidth = proposal.replacingUnspecifiedDimensions().width
        let fullHeight = proposal.replacingUnspecifiedDimensions().height
   
        let availableWidthToPropose = fullWidth
        let availableHeightToPropose = fullHeight
                    
        var sizes: [CGSize] = []
        
        for subview in subviews {
            let subviewProposedWidth = availableWidthToPropose/CGFloat(subviews.count)
            let subviewProposedHeight = availableHeightToPropose
            let subviewProposal = ProposedViewSize(width: subviewProposedWidth, height: subviewProposedHeight)
            let subviewSize = subview.sizeThatFits(subviewProposal)
            sizes.append(subviewSize)
        }
        
        let widthThatFits = sizes.reduce(0) { $0 + $1.width }
        let heightThatFits = sizes.reduce(0) { max($0, $1.height) }
        
        return CGSize(width: widthThatFits, height: heightThatFits)
        
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        
        let fullWidth = proposal.replacingUnspecifiedDimensions().width
        let fullHeight = proposal.replacingUnspecifiedDimensions().height
   
        let availableWidthToPropose = fullWidth
        let availableHeightToPropose = fullHeight
        
        var position = CGPoint(x: bounds.minX, y: bounds.midY)

        for subview in subviews {
            let subviewProposedWidth = availableWidthToPropose/CGFloat(subviews.count)
            let subviewProposedHeight = availableHeightToPropose
            let subviewProposal = ProposedViewSize(width: subviewProposedWidth, height: subviewProposedHeight)
            let subviewSize = subview.sizeThatFits(subviewProposal)
            subview.place(at: position, anchor: .leading, proposal: subviewProposal)
            position.x += subviewSize.width
        }
        
    }
    
}
