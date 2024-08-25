import SwiftUI

extension View {
    func dragRotation(sensitivity: Double = 10) -> some View{
        modifier(DragRotationModifier(sensitivity: sensitivity))

    }
}

private struct DragRotationModifier: ViewModifier {
    let sensitivity: Double
    @State private var yaw: Double = 0
    @State private var baseYaw: Double = 0

    func body(content: Content) -> some View {
        content
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
    }
}