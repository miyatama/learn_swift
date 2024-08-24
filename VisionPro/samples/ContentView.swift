import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        VStack {
            RealityView { content in
                let model = try! await Entity(
                    named: "Scene",
                    in: realityKitContentBundle
                )
                conetnt.add(model)
            }
            .padding(.bottom, 50)
            Text("hello world!")
            Button("click") {
                print("click")
            }
        }
        .paddin()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}