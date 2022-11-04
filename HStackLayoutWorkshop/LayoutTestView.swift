import SwiftUI

struct LayoutTestView<Content: View>: View {
    
    let width: CGFloat
    let height: CGFloat
    var spacing: CGFloat? = nil
    
    @StateObject private var ref = ChildrenFrameProxy()
    @StateObject private var sut = ChildrenFrameProxy()
    
    @ViewBuilder var content: Content
    
    let propertiesToShowValue = [
        FrameProperty(id: "x", keyPath: \.origin.x),
        FrameProperty(id: "width", keyPath: \.width),
    ]
    
    var body: some View {
        List {
            Section("HStackLayout") {
                build(layout: HStackLayout(spacing: spacing), proxy: ref)
            }
            Section("MyHStackLayout") {
                build(layout: MyHStackLayout(spacing: spacing), proxy: sut)
            }
        }
    }
    
    @ViewBuilder
    func build(layout: some Layout, proxy: ChildrenFrameProxy) -> some View {
        ChildrenFrameReader(layout: layout, proxy: proxy) { content }
            .frame(width: width, height: height)
            .border(.foreground)
            .padding()
            .frame(maxWidth: .infinity)
        Grid(alignment: .leading) {
            GridRow() {
                Text("ID")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(propertiesToShowValue) { property in
                    Text(property.id)
                        .textCase(.uppercase)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .bold()
            ForEach(proxy.ids, id: \.self) { id in
                GridRow {
                    Text(verbatim: id.description)
                    ForEach(propertiesToShowValue) { property in
                        let keyPath = property.keyPath
                        HStack {
                            Text(proxy[id]![keyPath: keyPath], format: .number.precision(.fractionLength(1)))
                            Spacer()
                            if proxy === sut {
                                let isCorrect = (sut[id]![keyPath: keyPath].isAlmostEqual(to: ref[id]![keyPath: keyPath]))
                                makeAssertIcon(for: keyPath, isCorrect: isCorrect)
                                    .padding(.trailing)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @ViewBuilder
    func makeAssertIcon(for keyPath: KeyPath<CGRect, CGFloat>, isCorrect: Bool) -> some View {
        Image(systemName: isCorrect ? "checkmark" : "xmark")
            .foregroundColor(isCorrect ? .green : .red)
            .symbolVariant(.square.fill)
            .fontWeight(.medium)
    }
    
}

struct LayoutTestView_Previews: PreviewProvider {
    static var previews: some View {
        LayoutTestView(width: 150, height: 100, spacing: 10) {
            Color.red
            Color.green
            Color.blue
        }
    }
}
