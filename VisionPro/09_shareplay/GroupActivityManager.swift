import Combine
import RealityKit
import GroupActivites
import SwiftUI

@Observable
class GroupActivityManager {
    var messenger: GroupSessionMessenger?
    var session: GroupSession<SampleActivity>?
    var reliableMessenger: GroupSessionMessenger?
    var subscription = Set<AnyCancellable>()
    var tasks = Set<Task<Void, Never>>()
    var isSharePlaying = false
    var emoji = Emoji.happy
    var pose = Pose3D()
    var isSpartial = false
    var entity: ModelEntity?

    func startSession() { 
        Task {
            do {
                _ = try await SampleActivity().activate()

            } catch {
                print("failed to activate SampleActivity: \(error)")
            }
        }

    }

    func configureGroupSession(session: GroupSession<SampleActivity>) async { 
        print("new GroupActivity session: \(session)")
        self.session = session

        // 購読・タスクをクリア
        subscription.removeAll()
        tasks.forEach { $0.cancel() }
        tasks.removeAll()

        messenger = GroupSessionMessenger(session: session, deliveryMode: .unreliable)

        reliableMessenger = GroupSessionMessenger(session: session, deliveryMode: .reliable)
        setupStateSubscription(for: session)
        setupParticipantsSubscription(for: session)
        setupEmojiMessageHandler()

        setupPoseMessageHandler()
        await setCoordinatorConfiguration(session: session)

        session.join()
        isSharePlaying = true
    }

    private func setupStateSubscription(for session: GroupSession<SampleActivity>) { 
        // $: state binding
        session.$state
            .sink { [weak self] state in
                if case .invalidated = state {
                    self?.endSession()
                }
            }
            .store(in: &subscription)
    }

    private func setupParticipantsSubscription(for session: GroupSession<SampleActivity>) { 
        session.$state
            .sink { [weak self] activeParticipants in
                guard let self else {return}
                let newParticipants = activeParticipants.subtracting(session)
                print("new participant: \(newParticipants)")
                self.sendEmojiMessage(message: EmojiMessage(emoji: self.emoji))
                self.sendPoseMessage(message: PoseMessage(pose: pose))
            }
            .store(in: &subscription)
    }

    private func setupEmojiMessageHandler() { 
        guard let reliableMessenger else { return }
        let emojiTask = Task {
            for await (message, sender) in reliableMessenger.messages(of: EmojiMessage.self) {
                print("sender: \(sender), message: \(message)")
                handleEmojiMessage(message: message)
            }
        }
        tasks.insert(emojiTask)
    }

    func handleEmojiMessage(message: EmojiMessage) { 
        print("emoji: \(message.emoji)")
        emoji = message.emoji
    }

    func sendEmojiMessage(message: EmojiMessage, to: Participants = .all) { 
        if let session, let reliableMessenger {
            let everyoneElse = session.activeParticipants.subtracting([session.localParticipant])
            reliableMessenger.send(message, to: .only(everyoneElse)) {
                if let error {
                    print("emoji message failed: \(error)")
                }
            }

        }
    }

    func endSession() {
        isSharePlaying = false
        reliableMessenger = nil
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
        subscriptions.removeAll()
        isSpartial = false
        messenger = nil
        if session != nil {
            session?.leave() 
            session = nil
        }
    }


    private func setupPoseMessageHandler() {
        guard let messenger else { return }
        let poseTask = Task {
            for await {message, _} in messenger.messages(of: PoseMessage.self) {
                handlePoseMessage(message: message)
            }
        }
        tasks.insert(poseTask)
    }

    func handlePoseMessage(message: PoseMessage) {
        pose = message.pose
    }

    func sendPoseMessage(message: PoseMessage) {
        print("pose: \(message)")
        if let session, let messenger {
            let everyoneElse = session.activeParticipants.subtracting([session.localParticipant])
            if isSpartial {
	            messenger.send(message, to: .only(everyoneElse)) {
	                if let error {
	                    print("emoji message failed: \(error)")
	                }
	            }
            }
        }
    }

    private func setCoordinatorConfiguration(session: session) async {
        if let coordinator = await session.systemCoordinator {
            var config = SystemCoordinator.Configuration()
            config.spartialTemplatePreference = .sideBySide
            config.supportGroupImmersiveSpace = true
            coordinator.configuration = config
            Task.detached { @MainActor in
                for await state in coordinator.localParticipantStates {
                    if state.isSpartial {
                        self.isSpartial = true
                    } else {
                        self.isSpartial = false
                    }
                }
            }
        }
    }
}