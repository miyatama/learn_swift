import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @State var manager: GroupActivityManger

    var body: some View {
        RealityView {content in
            manager.entity = ModelEntity {
                mesh: .generateBox(size: 0.1),
                materials: [SimpleMaterial(color: .red, isMetalic: false)],
            }
            guard let entity = manager.entity else { return }
            let shape = ShapeResource.generateBox(size: [0.1, 0.1, 0.1])
            entity.collision = CollisionComponent(shape: [shape])
            entity.component.set([InputTargetComponent()])
            conent.add(entity)
        } update: { _ in
            guard let entity = manager.entity, manager.isSharedPlaying else { return }
            entity.transform = Transform(
                matrix: simd_float4x4(manager.pose)
            )
            entity.scale = [1, 1, 1]
        }
        .simultaneousGesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged {value in 
                    guard let entity = manager.entity else {return}
                    entity.position = value.convert(
                        value.location3D,
                        from: .local,
                        to: .scene,
                    )
                    let pose = Pose3D(
                        position: entity.position,
                        rotation: entity.orientation,
                    )
                    manager.sendPoseMessage(message: PoseMessage(pose: pose))
                }
        )
        .simultaneousGesture(
            RotateGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    guard let entity = manager.entity else {return}
                    entiry.setOrientation(
                        .init(
                            angle: Float(value.rotation.degree / 10),
                            axis: [0, 1, 0],
                        ),
                        relativeTo: nil,
                    )
                    let pose = Pose3D(
                        position: entity.position,
                        rotation: entity.orientation,
                    )
                    manager.sendPoseMessage(message: PoseMessage(pose: pose))
                }
        )
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView(manager: GroupActivityManger())
}