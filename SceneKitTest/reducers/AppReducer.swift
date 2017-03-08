import ReSwift

struct AppReducer: Reducer {
	
	func handleAction(action: Action, state: State?) -> State {
		return State(
			repositories:repositoriesReducer(repositories: state?.repositories, action: action)!,
			bookmarks:bookmarksReducer(bookmarks: state?.bookmarks, action: action),
			status:statusReducer(status: (state?.status)!, action: action),
			codeStatus:codeStatusReducer(status: (state?.codeStatus)!, action: action),
			gStatus:gestureStatusReducer(status: (state?.gStatus)!, action: action)
		);
	}
}
