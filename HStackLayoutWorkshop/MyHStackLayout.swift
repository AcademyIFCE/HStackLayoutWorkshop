import SwiftUI

extension LayoutSubview {
    
    var flexibility: (width: CGFloat, height: CGFloat) {
        let minSize = dimensions(in: .zero)
        let maxSize = dimensions(in: .infinity)
        return (maxSize.width - minSize.width, maxSize.height - minSize.height)
    }
    
}

struct MyHStackLayout: Layout {
    
    struct Cache {
        var proposals: [Int: ProposedViewSize] = [:]
    }

    var spacing: CGFloat? = nil
    
    func makeCache(subviews: Subviews) -> Cache {
        return Cache()
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        
        let spacing = spacing ?? 8
        
        let fullWidth = proposal.replacingUnspecifiedDimensions().width
        let fullHeight = proposal.replacingUnspecifiedDimensions().height
        
        let allSpacings = CGFloat(subviews.count - 1) * spacing
   
        var availableWidthToPropose = fullWidth - allSpacings
        let availableHeightToPropose = fullHeight
                    
        var sizes: [CGSize] = []
        
        var numberOfSubviewsRemainingToPropose = subviews.count
        
        let indexedSubviews = subviews.enumerated().map({ (index: $0.offset, subview: $0.element) })
        
        let indexedSubviewsSortedByWidthFlexibility = indexedSubviews.sorted(using: KeyPathComparator(\.subview.flexibility.width))
                
        for (index, subview) in indexedSubviewsSortedByWidthFlexibility {
            let subviewProposedWidth = availableWidthToPropose/CGFloat(numberOfSubviewsRemainingToPropose)
            let subviewProposedHeight = availableHeightToPropose
            let subviewProposal = ProposedViewSize(width: subviewProposedWidth, height: subviewProposedHeight)
            let subviewSize = subview.sizeThatFits(subviewProposal)
            cache.proposals[index] = subviewProposal
            sizes.append(subviewSize)
            availableWidthToPropose -= subviewSize.width
            numberOfSubviewsRemainingToPropose -= 1
        }
        
        let widthThatFits = sizes.reduce(0) { $0 + $1.width } + allSpacings
        let heightThatFits = sizes.reduce(0) { max($0, $1.height) }
        
        return CGSize(width: widthThatFits, height: heightThatFits)
        
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        
        let spacing = spacing ?? 8
        
        var position = CGPoint(x: bounds.minX, y: bounds.midY)

        for (index, subview) in subviews.enumerated() {
            let subviewProposal = cache.proposals[index]!
            let subviewSize = subview.sizeThatFits(subviewProposal)
            subview.place(at: position, anchor: .leading, proposal: subviewProposal)
            position.x += subviewSize.width + spacing
        }
        
    }
    
}
