import SwiftUI

struct ContentView2: View {
    let url = "https://developer.apple.com/augumented-reality/quick-look/teapot/teapot.usdz"
    var body: some View {
        Model3D(url: URL(string: url)!) { model in
            // conetntMode: .fit or .fill
            model
                .resizable()
                .aspectRatio(contentMode: .fit)
                // DragRotationModifier: public -> private
                // .modifier(DragRotationModifier())
                .dragRotation()
        }.placeholder: {
            ProgressView()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView2()
}