import Foundation
import ReSwift

func statusReducer(status: Bool, action: Action) -> Bool {
	switch action {
	case let action as StatusAction:
		return action.status;
	default:
		return status;
	}
}
