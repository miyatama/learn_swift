import SwiftUI

@main
struct ShootingGameApp: App {
    var body: some Scene {
        WidnowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}