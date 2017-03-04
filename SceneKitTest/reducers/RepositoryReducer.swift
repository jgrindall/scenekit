import ReSwift

func repositoriesReducer(state: [Int]?, action: Action) -> [Int]? {
	switch action {
	case let action as RepositoriesAction:
		return action.repositories
	default:
		return []
	}
}
