import SwiftUI

struct ContentView2: View {
    let url = "https://developer.apple.com/augumented-reality/quick-look/teapot/teapot.usdz"
    let sensitivity: Double = 10
    @State private var yaw: Double = 0
    @State private var baseYaw: Double = 0
    var body: some View {
        Model3D(url: URL(string: url)!) { model in
            // conetntMode: .fit or .fill
            model
                .resizable()
                .aspectRatio(contentMode: .fit)
                // rotate 180 axis y
                //  .radians(.pi) = .degree(180)
                //  axis: .y = axis: (x: 0.0, y: 1.0, z: 0.0)
                // .rotation3DEffect(.radians(.pi), axis: .y)
                .rotation3DEffect(.radians(yaw), axis: .y)
                .targetAnyEntity()
                // drag gesture
                .gesture(DragGesture(minimumDistance: 0.0)
	                .onChange { value in
                        // value: dragging value
	                    print("in dragging")
                        // location3D: dragging current position value
                        let location3D = value.convert(value.location3D, from: .local, to: .scene)
                        // location3D: dragging start position value
                        let startLocation3D = value.convert(value.startLocation3D, from: .local, to: .scene)
                        let delta = location3D - startLocation3D

                        // delta.x: horizontal swipe distance = y axis rotation value
                        yaw = baseYaw + Double(delta.x) * sensitivity
	                }
	                .onEnbed { value in 
	                    print("finish to dragging")
                        baseYaw = yaw 
	                }
                )
        }.placeholder: {
            ProgressView()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView2()
}