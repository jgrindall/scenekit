import Foundation
import ReSwift

func codeStatusReducer(status: String, action: Action) -> String {
	switch action {
	case let action as CodeStatusAction:
		return action.status;
	default:
		return status;
	}
}
