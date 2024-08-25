import Foundation
import ARKit

@MainActor
class HandTracking: ObservableObject {
    @Published var leftIndex: simd_float4x4?
    @Published var rightIndex: simd_float4x4?

    func run() async {
        let session = ARKitSession()
        let handInfo = HandTrackingProvider()

        do {
            guard HandTrackingProvider.isSupported else {return}
            try await session.run([handInfo])

        } catch {
            print("Error: \(error)")
        }

        for await update in handInfo.anchorUpdates {
            guard update.anchor.isTracked else {continue}
            switch update.event {
                case .updated:
                    if let skeleton = update.anchor.handSkeleton {
                        let index = skeleton.joint(.indexFingerIntermediateBase).anchorFromJointTransform
                        let root = update.anchor.originFromAnchorTransform

                        // coodinate change to world
                        let worldIndex = root * index
                        if update.anchor.chirality == .left {
                            leftIndex = worldIndex
                        } else {
                            rightIndex = worldIndex
                        }
                    }
                default: 
                    break
            }
        }
    }

}

extension simd_float4x4 {
    var position: simd_float3 {
        let pos = self.columns.3
        return simd_float3(pos.x, pos.y, pos.z)
    }
}
