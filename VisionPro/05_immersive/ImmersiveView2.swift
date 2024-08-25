import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView2: View {
    @State private var earth: Entity?
    @State private var moon: Entity?
    @State private var rocket: Entity?
    var body: some View {
        RealityView { content in
            do {
	            if let earth = try? await Entity(named: "Earth", in: realityKitContentBundle) {
                    earth.components.set([InputTargetComponent()])
                    let shape = SnapResource.generateSphere(radious: 0.1)
                    earth.components.set(CollisionComponent(shapes: [shape]))

                    earth.position = [-1, 1, -1]
	                content.add(earth)
                    self.earth = earth
	            }
	            if let moon = try? await Entity(named: "Moon", in: realityKitContentBundle) {
                    moon.components.set([InputTargetComponent()])
                    let shape = SnapResource.generateSphere(radious: 0.1)
                    moon.components.set(CollisionComponent(shapes: [shape]))
                    moon.position = [1, 1, -1]
	                content.add(moon)
                    self.moon = moon
	            }
	            if let rocket = try? await Entity(named: "ToyRocket", in: realityKitContentBundle) {
                    rocket.component.set([MoveComponent()])
                    rocket.position = [0, 1, -1]
	                content.add(rocket)
                    self.rocket = rocket
	            }
            } catch {
                print(error.localizedDescription)
            }
        }
        .gesture(SpatialTapGesture()
	        .targetedAnyEntity()
	        .onEnded { value in
	            print("tapped: \(value.entity.name)")

                // null safe
                guard let earth = self.earth, let moon = self.moon, let rocket = self.rocket
                    else { return }

                if value.entity == earth {
                    // rocket move to earth
                    // rocket.position = earth.position + [0.33, 0, 0]
                    if var component: MoveComponent = rocket.components[MoveComponent.self] {
                        component.speed = -0.7
                        component.start = moon.position
                        component.end = earth.position + [0.25,0, 0]
                        component.isEnabled = true
                        rocket.components[MoveComponent.self] = component
                    }
                    let rotation = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 0, 1))
                    rocket.orientation = rotation
                } else if value.entity == moon {
                    // rocket move to moon
                    // rocket.position = moon.position - [0.33, 0, 0]
                    if var component: MoveComponent = rocket.components[MoveComponent.self] {
                        component.speed = 0.7
                        component.start = earth.position
                        component.end = moon.position - [0.25,0, 0]
                        component.isEnabled = true
                        rocket.components[MoveComponent.self] = component
                    }
                    let rotation = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(0, 0, 1))
                    rocket.orientation = rotation
                }
	        })
    }
}