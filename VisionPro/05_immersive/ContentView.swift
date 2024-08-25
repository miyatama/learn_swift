import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    // toggle button state
    @State private var showImmersiveSpace = false

    // immersive showing state
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dissmissImmersiveSpace) var dissmissImmersiveSpace

    var body: some View {
        VStack {
            Model3D(name: "Scene", bundle: realityKitContentBundle)
                .padding()
            Text("hello world")

            Toggle("show immersive", isOn: $showImmersiveSpace)
                .font(.title)
                .frame(width: 300)
                .padding(24)
                .glassBackgroundEffect()

        }
        .padding()
        // observable toggle state
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    // id decratation in App
                    switch await openImmersiveSpace(id: "immersiveSpace") {
                        case .opened:
                            immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dissmissImmersiveSpace {
                        immersiveSpaceIsShown = false
                    }
                }
            }
        }
    }
}