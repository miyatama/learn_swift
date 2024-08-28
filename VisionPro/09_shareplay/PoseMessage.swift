import SwiftUI

struct EmojiMessage: Codable {
    let emoji: Emoji
}

struct PoseMessage: Codable {
    let pose: Pose3D
}