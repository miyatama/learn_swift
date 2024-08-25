import SwiftUI

@main
struct VolumeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView2()
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.5, height: 0.5, depth: 0.5, in: .meters)
    }
}