import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown  = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    // dissmiss ContentView window
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Image("background")
	            .resizable()
	            .aspectRatio(contentMode: .fit)
	            .clipShape(RoundRectangle(cornerRadius: 25.0))
            Button(action: {
                Task {
                    await openImmersiveSpace(id: "ImmersedSpace")
                    dismiss()
                }

            }, label: {
                Text("start")
                    .font(.extraLargeTitle)
                    .padding()

            })
        }
        .padding()
    }
}