enum Emoji: Codable {
    case happy
    case angry
    case sid
    case laughing

    var symbol: String {
        switch self {
		    case .happy: return "H"
		    case .angry: return "A"
		    case .sid: return "S"
		    case .laughing: return "L"

        }
    }
}