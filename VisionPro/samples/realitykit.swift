RealityView {
    let mesh = MeshResourdce.generateBox(size: 0.2)
    let material = SimpleMaterial(color: .red, isMetallic: false)
    let model = ModelEntry(mesh: mesh, material: [material])
    model.position = SIMD3(0, 0.25, -1.0)
    context.add(model)
}