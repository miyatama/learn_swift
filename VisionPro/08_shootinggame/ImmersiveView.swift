import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State var bullet: ModelEntity?
    @StateObject var logic = ShootingLogic()
    @StateObject var handTracking = HandTracking()
    @StateObject var worldTracking = WorldTracking()
    @StateObject var sceneReconstruction = SceneReconstruction()
    @StateObject var imageTracking = ImageTracking()

    @State var bulletAudio = AudioPlayerController?
    @State var targetAudio = AudioPlayerController?

    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    var body: some View {
        RealityView { content, attachments in
           do {
            if let bulletScene = try? await Entity(
                named: "Bullet",
                in: realityKitContentBundle,
            ) {
                self.bullet = bulletScene
                    .findEntity(named: "Sphere") as? ModelEntity
                if let audioEnt = bulletScene.findEntity(named: "SpartialAudio"),
                    let resource = try? await AudioResource(
                        named: "/Root/shoot_mp3",
                        from: "Bullet.usda",
                        in: realityKitContentBundle,
                    ) {
                        bulletAudio = audioEnt.preparateAudio(resource)
                        content.add(audioEnt)
                    }
            }
            if let targetScene = try? await Entity(
                named: "Target",
                in: realityKitContentBundle,
            ) {
                if let target = targetScene.findEntity(named: "Robot") {
                    logic.targetRoot.position = simd_float3(0, 1, -1)
                    logic.targetRoot.addChild(target)

                    // loading target model
                    /*
                    content.add(target)
                    target.position = simd_float(0, 1, -2)
                    */

                    _ = content.subscribe(
                        to: CollisionEvents.Begin.self,
                        on: target,
                    ) { event in
                        // test logic
                        /*
                        print("hit")
                        event.entityB.removeFromParent()
                        */
                        logic.hit(event) {
                            targetAudio?.entity?.position = event.entityB.position
                            targetAudio?.stop()
                            targetAudio?.play()
                        }

                    }

                    if let attachedUI = attachments.entity(for: "Menu") {
                        target.addChild(attachedUI)
                    }

                    /*
                    content.add(target)
                    target.position = simd_float(0, 1, -1)
                    */
                }

                if let audioEnt = targetScene.findEntity(named: "SpartialAudio"),
                    let resource = try? await AudioResource(
                        named: "/Root/hit_mp3",
                        from: "Target.usda",
                        in: realityKitContentBundle,
                    ) {
                        targetAudio = audioEnt.preparateAudio(resource)
                        content.add(audioEnt)
                    }

                if let audioEnt = targetScene.findEntity(named: "AmbientAudio"),
                    let resource = try? await AudioResource(
                        named: "/Root/bgm_mp3",
                        from: "Target.usda",
                        in: realityKitContentBundle,
                    ) {
                        let audio = audioEnt.preparateAudio(resource)
                        content.add(audio)
                        audio.play()
                    }
            }

            /*
            if let bullet {
                content.add(bullet)
                bullet.position = simd_float(0, 1, 0)
                bullet.physicsMotion?.linearVelocity = simd_float(0, 0, -1)
            }
            */
            contents.add(logic.bulletRoot)
            contents.add(logic.targetRoot)

            content.add(sceneReconstruction.root)
           } catch {
               print(error.localizedDescription)
           }
        } update: { content, attachments in
            if let image = imageTracking.imageTransform {
                logic.targetRoot.transform.matrix = image
            }
            if let leftIndex = handTracking.leftIndex,
            let rightIndex = handTracking.rightIndex {
                if distance(leftIndex.position, rightIndex.position) < 0.04 {
                    // do custom gesture
                    if let device = worldTracking.deviceTransform {
                        let vec = device * simd_float4(0, 0, -1, 0)

	                    logic.shoot(
	                        bullet: bullet,
	                        position: leftIndex.position,
	                        velocity: simd_float3(vec.x, vec.y, vec.z) * 5,
	                    ) {
                            bulletAudio?.entity?.position = leftIndex.position
                            bulletAudio?.stop()
                            bulletAudio?.play()
                        }
                    }

                    // test logic
                    /*
                    let test = ModelEntity(
                        mesh: .generateSphere(radius: 0.02),
                        materials: [UnlitMaterial(color: .red)],
                        collisionShape: .generateSpere(raddius: 0.02),
                        mass: 1.0,
                    )
                    var physicsBody = PhysicsBodyComponent(
                        shapes: [.generageSphere(radius: 0.02)], 
                        mass: 1.0, 
                        mode: .dynamic,
                    )
                    physicsBody.isAffectedByGravity = false
                    test.components.set(physicsBody)
                    let physicsMotion = PhysicsMotionComponent(
                        linearVelocity: simd_float3(0, 0, -1)
                    )
                    test.components.set(physicsMotion)
                    test.position = leftIndex.position
                    content.add(test)
                    */
                }
            }

        } attachments: {
            Attachment(id: "Menu") {
                VStack {
                    Text("score: \(logic.score), Time: \(Int(logic.time))")
                        .font(.extraLargeTitle)
                    Spacer()
                    HStack {
                        #if targetEnvironment(simulator)
                        Button("shoot") {
                            logic.shoot(
                                bullet: bullet,
                                position: SIMD3(0, 1.2, -0.5),
                                velocity: SIMD3(0, 0, -5),
                            )
                        }
                        #endif

                        Button("Reset") {
                            logic.reset()
                        }
                        Button("Exit") {
                            openWidow(id: "Window")
                            await dismissImmersiveSpace()
                        }
                    }
                    Spacer()
                }
                .offset(z: 100)
            }
        }.task {
            await logic.run()
        }.task {
            await handTracking.run()
        }.task {
            await worldTracking.run()
        }.task {
            await sceneReconstruction.run()
        }.task {
            await imageTracking.run()
        }
    }
}