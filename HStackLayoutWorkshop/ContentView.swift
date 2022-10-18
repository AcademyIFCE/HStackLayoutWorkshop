import SwiftUI

struct ContentView: View {
    
    @StateObject var proxy = ChildrenFrameProxy()
    
    var body: some View {
        List {
            
            ChildrenFrameReader(layout: HStackLayout(spacing: 0), proxy: proxy) {
                Color.red
                    .frame(maxWidth: 100)
                Color.green
                    .frame(minWidth: 100)
            }
            .frame(width: 150, height: 100)
            .border(.black)
            .frame(maxWidth: .infinity)
            
            ForEach(proxy.ids, id: \.self) { id in
                LabeledContent(String("\(id)"), value: proxy[id]?.width.formatted() ?? "?")
            }
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
