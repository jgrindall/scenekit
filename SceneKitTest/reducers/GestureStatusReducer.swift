import Foundation
import ReSwift

func gestureStatusReducer(status: Bool, action: Action) -> Bool {
	switch action {
	case let action as GestureStatusAction:
		return action.status;
	default:
		return status;
	}
}
