struct ContentView: View {
    @State var enlarge = false
    var body: some View {
        VStack {
            RealityView {
                // load entity named Scene
                if let scene = try? await Entity(
                    name: "Scene",
                    in: realityKitContentBundle
                ) {
                    conetnt.add(scene)
                }
            }.update: { conent in
                // trigger: update Swift UI state
                if let scene = content.entities.first {
                    let uniformScale: Float = enlarge ? 1.4 : 1.0
                    scene.transform.scale = [uniformScale,uniformScale,uniformScale]
                }
            }.gesture(TapGesture().targetedAnyEntity().onEnbed { _ in
                // onEnbed(): trigger release by device
                enlarge.toggle()
            })

            VStack {
                Toggle("Enlarge RealityView Content(automatic)", isOnd: $enlarge)
                .toggelStyle(.automatic)
                Toggle("Enlarge RealityView Content(button)", isOnd: $enlarge)
                .toggelStyle(.button)
                Toggle("Enlarge RealityView Content(switch)", isOnd: $enlarge)
                .toggelStyle(.switch)

            }.padding().frame(width: 200).glassBackgroundEffect()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}