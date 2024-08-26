import Foundation
import ARKit
import RealityKit

@MainActor
class SceneReconstruction: ObservableObject {
    var root = Entity()
    private var meshEntities = [UUID: ModelEntry]()
    func run() async {
        let session = ARKitSession()
        let sceneReconstruction = SceneReconstructionProvider()
        do {
            guard SceneReconstructionProvider.isSupported else {return}
            try await session.run([sceneReconstruction])

        } catch {
            print("Error: \(error)")
        }

        for await update in sceneReconstruction.anchorUpdates {
            let meshAnchor = update.anchor
            guard let shape = try? await ShapeResource
                .generateStaticMesh(from: meshAnchor) else {continue}
            switch update.event {
                // new hardle
                case .added:
                    let entity = ModelEntity()
                    entity.transform = Transform(
                        matrix: meshAnchor.originFromAnchorTransform
                    )
                    entity.collision = CollisionComponent(
                        shapes: [shape],
                        isStatic: true
                    )
                    entity.components.set(InputTargetComponent())
                    entity.physicsBody = PhysicsBodyComponent(mode: .static)
                    meshEntities[meshAnchor.id] = entity
                    root.addChild(entity)
                    break
                // change hardle sape
                case .updated:
                    guard let entity = meshEntities[meshAnchor.id] else { continue }
                    entity.transform = Transform (
                        matrix: meshAnchor.originFromAnchorTransform
                    )
                    entity.collision?.shapes = [shape]
                    break
                // gone hardle
                case .removed:
                    meshEntities[meshAnchor.id]?.removeFromParent()
                    meshEntities.removeValue(forKey: meshAnchor.id)
                    break
            }
        }
    }
}