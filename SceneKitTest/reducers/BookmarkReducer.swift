import Foundation
import ReSwift

func bookmarksReducer(state: [String]?, action: Action) -> [String] {
	var newState = (state != nil) ? state! : [];
	switch action {
	case let action as BookmarkAction:
		newState.append(action.route);
		print("new state!", newState);
		return newState;
	default:
		return newState;
	}
}
