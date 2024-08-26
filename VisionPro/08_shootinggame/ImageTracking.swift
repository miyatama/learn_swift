import Foundation
import ARKit
import RealityKit

@MainActor
class ImageTracking: ObservableObject {
    @Published var imageTransform: simd_float4x4?

    func run() async {
        guard let image = UIImage(named: "background")?.cgiImage else {return}
        let referenceImage = ReferenceImage (
            cgiImage: image,
            // 16cm * 9cm
            physicalSize: GCSize(width: 0.16, height: 0.09)
        )

        let session = ARKitSession()
        let imageTrackingProvider = ImageTrackingProvider(referenceImages: [referenceImage])
        do {
            guard ImageTrackingProvider.isSupported else { return }
            try await session.run([imageTrackingProvider])
        } catch {
            print("Error: \(error)")
        }

        for await update in imageTrackingProvider.anchorUpdates {
            switch update.event {
                case .added:
                    break
                case .updated:
                    imageTransform = update.anchor.originFromAnchorTransform
                    break
                case .removed:
                    break
            }

        }
    }
}