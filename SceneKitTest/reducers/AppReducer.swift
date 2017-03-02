import ReSwift

struct AppReducer: Reducer {
	
	func handleAction(action: Action, state: State?) -> State {
		return State(
			repositories:
				repositoriesReducer(state: state?.repositories, action: action),
			bookmarks:
				bookmarksReducer(state: state?.bookmarks, action: action)
		)
	}
}
