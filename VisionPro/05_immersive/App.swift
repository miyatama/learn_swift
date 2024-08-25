import SwiftUI

@main
struct ImmersiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "immersiveSpace") {
            ImmersiveView()
        }
    }

    init() {
        MoveComponent.registerComponent()
        MoveSystem.registerSystem()
    }
}