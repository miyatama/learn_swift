import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            /*
            if let scene = try? await Entity(named: "immersive", in: realityKitContentBundle) {
                content.add(scene)
            }
            */
            do {
	            if let earth = try? await Entity(named: "Earth", in: realityKitContentBundle) {
                    earth.components.set([InputTargetComponent()])
                    let shape = SnapResource.generateSphere(radious: 0.1)
                    erth.components.set(CollisionComponent(shapes: [shape]))

                    // eq: earth.position = SIMD3(-1, 1, -1)
                    // eq: earth.translation = [-1, 1, -1]
                    earth.position = [-1, 1, -1]
	                content.add(earth)
	            }
	            if let moon = try? await Entity(named: "Moon", in: realityKitContentBundle) {
                    moon.components.set([InputTargetComponent()])
                    let shape = SnapResource.generateSphere(radious: 0.1)
                    moon.components.set(CollisionComponent(shapes: [shape]))
                    moon.position = [1, 1, -1]
	                content.add(moon)
	            }
	            if let rocket = try? await Entity(named: "ToyRocket", in: realityKitContentBundle) {
                    rocket.position = [0, 1, -1]
	                content.add(rocket)
	            }
            } catch {
                print(error.localizedDescription)
            }
        }
        .gesture(SpatialTapGesture()
	        .targetedAnyEntity()
	        .onEnded { value in
	            print("tapped: \(value.entity.name)")
	        })
    }
}