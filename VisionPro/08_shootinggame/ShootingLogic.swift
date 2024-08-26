import Foundation
import RealityKit

@MainActor
class ShootingLogic: ObservableObject {
    var bulletRoot = Entity()
    var targetRoot = Entity()

    @Published var time: Float = 30
    @Published var score: Int = 0

    private var previousTime: Float = 30

    func run() async {
        while true {
            let interval :Float = 1.0 / 200
            let intervalNanos = UInt64(Float(NSEC_PER_SEC) * interval)
            do {
                try await Task.sleep(nanoseconds: intervalNanos)
            } catch {
                // task cancelled
                return
            }

            time -= interval
            if time < 0.0 {
                time = 0.0
            } else {
                targetRoot.children.first?.position = simd_float3(sin(time / 2.0) / 2.0, 0, 0)
            }

        }
    }

    func reset() {
        bulletRoot.children.removeAll()
        score = 0
        time = 30
        previousTime = 30
    }

    func shoot(
        bullet: ModelEntity?,
        position: simd_float3,
        velocity: simd_float3,
        shootAction: () -> Void,
    ) {
        guard time > 0.0 && previousTime - time >= 0.1 else { return }
        previousTime = time
        if let bullet {
            let bulletClone = bullet.clone(recursive: true)
            bulletClone.position = position
            bulletClone.physicsMotion?.linearVelocity = velocity
            bulletRoot.addChild(bulletClone)    

            shootAction()
        }
    }

    func hit(
        _ event: CollisionEvents.Began,
        hitAction: () -> Void,
    ) {
        if event.entityA.name != event.entityB.name {
            score += 1
            event.entityB.removeFromParent
            hitAction()
        }
    }
}