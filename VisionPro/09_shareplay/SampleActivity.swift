import GroupActivites

struct SampleActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var data = GroupActivityMetadata()
        data.title = "Sample App"
        data.type = .generic
        return data
    }
}