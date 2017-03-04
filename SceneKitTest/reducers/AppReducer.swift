import ReSwift

struct AppReducer: Reducer {
	
	func handleAction(action: Action, state: State?) -> State {
		let newRep = repositoriesReducer(state: state?.repositories, action: action)
		let newB = bookmarksReducer(state: state?.bookmarks, action: action);
		return State(repositories:newRep!, bookmarks:newB);
	}
}
