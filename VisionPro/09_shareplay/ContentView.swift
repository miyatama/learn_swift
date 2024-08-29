import GroupActivities
import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var showImmersiveSpace = false
    @State private var imemrsiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    @State var manager: GroupActivityManager
    @State private var groupStateObserver = GroupStateObserver()
    var body: some View {
        VStack {
            Text("share play!")
            if !manager.isSharedPlaying {
                Button("start session") {
                    manager.startSession()
                }
                .disabled(!groupStateObserver.isEligibleGroupSession

            } else {
                Button("leave") {
                    manager.endSession()
                }
            }
            Text(manager.emoji.symbol)
                .font(.system(size: 200))
            HStack {
                Button("happy") {
                    manager.emoji = .happy
                    manager.sendEmojiMessage(message: EmojiMessage(emoji: .happy))
                }
                Button("angry") {
                    manager.emoji = .angry
                    manager.sendEmojiMessage(message: EmojiMessage(emoji: .angry))
                }
                Button("sad") {
                    manager.emoji = .sad
                    manager.sendEmojiMessage(message: EmojiMessage(emoji: .sad))
                }
                Button("laughing") {
                    manager.emoji = .laughing
                    manager.sendEmojiMessage(message: EmojiMessage(emoji: .laughing))
                }
            }
            Toggle("Show Immersive", isOn: $showImmersiveSpace)
                .font(.title)
                .frame(width: 360)
                .padding(24)
                .grassBackgroundEffect()
        }
        .padding()
        .onChanged(of: $showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                        case .opened:
                            imemrsiveSpaceIsShown = true
                        case .error, .userCancelled:
                            failthrough
                        @unknown default:
                            imemrsiveSpaceIsShown = false
                            showImmersiveSpace = false

                    }

                } else if imemrsiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    imemrsiveSpaceIsShown  = false
                }
            }
        }
        .task {
            for await session in SampleActivity.sessions() {
                await manager.configureGroupSession(session: session)
            }
        }
    }

}

#Preview() {
    ContentView(manager: GroupActivityManager())
}