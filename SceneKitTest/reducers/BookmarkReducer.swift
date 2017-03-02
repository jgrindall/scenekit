import Foundation
import ReSwift

func bookmarksReducer(state: [Bookmark]?, action: Action) -> [Bookmark] {
	var state = state ?? []
	
	switch action {
	case let action as CreateBookmark:
		let bookmark = (route: action.route, data: action.data)
		state.append(bookmark)
		return state
	default:
		return state
	}
}
