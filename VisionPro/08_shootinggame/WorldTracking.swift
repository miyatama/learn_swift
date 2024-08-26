import Foundation
import ARKit

import QuartsCore

@MainActor
class WorldTracker: ObservableObject {
    private let session = ARKitSession()
    private let worldTracking = WorldTrackingProvider()

    func run() { 
        do {
            guard WorldTrackingProvider.isSupported else { return }
            try await session.run([worldTracking])
        } catch {
            print("Error \(error)")
        }
    }

    var deviceTransform: simd_float4x4? {
        let device = worldTracking
            .queryDeviceAnchor(
                atTimestamp: CACurrentMediaTime())
            )
        return device?.originFromAnchorTransform

    }
}