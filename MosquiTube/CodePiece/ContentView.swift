import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundRectangle())
            Button(
                action: {
	                Task {
	                    await openImmersiveSpace(id: "ImmersiveSpace")
	                    dismiss()
	                }
	            },
                label: {
                    Text("Start MosquiTube")
                        .font(.extraLargeTitle)
                        .padding()
                }
            )
        }
        .padding()
    }
}