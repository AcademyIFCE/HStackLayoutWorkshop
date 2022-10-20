import SwiftUI

struct LayoutTestView<Content: View>: View {
    
    @StateObject private var ref = ChildrenFrameProxy()
    @StateObject private var sut = ChildrenFrameProxy()
    
    @ViewBuilder var content: Content
    
    var body: some View {
        List {
            Section("HStackLayout") {
                build(layout: HStackLayout(spacing: 0), proxy: ref)
            }
            Section("MyHStackLayout") {
                build(layout: MyHStackLayout(spacing: 0), proxy: sut)
            }
        }
    }
    
    @ViewBuilder
    func build(layout: some Layout, proxy: ChildrenFrameProxy) -> some View {
        ChildrenFrameReader(layout: layout, proxy: proxy) { content }
            .frame(width: 150, height: 100)
            .border(.foreground)
            .padding()
            .frame(maxWidth: .infinity)
        ForEach(proxy.ids, id: \.self) { id in
            LabeledContent(id.description) {
                Text(proxy[id]!.width.formatted())
                if proxy === sut {
                    let isCorrect = (proxy[id]!.width == ref[id]!.width)
                    Image(systemName: isCorrect ? "checkmark" : "xmark")
                        .foregroundColor(isCorrect ? .green : .red)
                        .symbolVariant(.square.fill)
                        .fontWeight(.medium)
                }
            }
        }
    }
    
}

struct LayoutTestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LayoutTestView {
                Color.blue
                Color.yellow
                    .frame(width: 100)
            }
        }
    }
}
