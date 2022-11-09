import SwiftUI

struct ContentView: View {
    
    var body: some View {
        LayoutTestView(width: 150, height: 100, spacing: 10) {
            Color.yellow
            Color.blue
            Color.pink
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
