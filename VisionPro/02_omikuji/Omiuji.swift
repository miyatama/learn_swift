import Foundation
import SwiftUI

class Omikujii {
    private enum KujiType: String, CaseIterable {
        case Daikichi = "omikuji_box_daikichi"
        case Chukichi = "omikuji_box_chukichi"
        case Shokichi = "omikuji_box_shokichi"
        case Kichi = "omikuji_box_kichi"
    }
    // 競合を避けるためのアンスコ
    private var result_: KujiType = .Daikichi

    func select() {
        result_ = KujiType.allCases.randomElement()!
    }

    func result() -> String {
        return result_.rawValue
    }

    func resultColor() -> Color {
        switch result_ {
	        case .Daikichi :
                return Color.red
	        case .Chukichi :
	            return Color.orange
	        case .Shokichi : 
	            return Color.green
	        case .Kichi :
	            return Color.blue
        }
    }
}