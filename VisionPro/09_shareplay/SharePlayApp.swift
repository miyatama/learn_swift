@main
struct SharePlayApp: App {
    let manager = GroupActivityManager()
    var body: some Scene {
        WindowGroup {
            ContentView (manager: manager)
        }

        ImmersiveSpace {
            ImmersiveView(manager: manager)
        }
    }
}