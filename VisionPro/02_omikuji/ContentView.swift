import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    let omikuji = Omikuji()
    @State var isRunning = false
    @State var angle = 0.0
    @State var opacity = 1.0
    var body: some View {
        VStack {
            Text("omikuji!").padding().front(.largeTtile)
            ZStack {
	            Image("omikuji_box")
	                .resizable()
	                .aspectRatio(contentMode: .fit)
	                .frame(height: 200)
                    .rotationEffect(.degree(angle))
                    .opacity(opacity)
	            Image(omikuji.result())
	                .resizable()
	                .aspectRatio(contentMode: .fit)
	                .frame(height: 200)
	                .background(omikuji.resultColor())
	                .clipShape(Circle())
                    .opacity(1.0 - opacity)
            }
            HStack {
	            Button("try") {
	                isRunning = true
                    omikuji.select()
                    withAnimation {
                        angle = 180
                    } completion {
                        withAnimation {
                            opacity = 0.0
                        }
                    }
	            }.disabled(isRunning)
	            Button("re-try"){
	                isRunning = false
                    angle = 0
                    opacity = 1.0
	            }.disabled(!isRunning)
            }
            .padding()
        }
        .padding()
    }

}

#Preview(windowStyle: .automatic) {
    ContentView()
}