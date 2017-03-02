import ReSwift

func repositoriesReducer(state: [Int]?, action: Action) -> [Int]? {
	switch action {
	case let action as SetRepositories:
		return action.repositories
	default:
		return nil
	}
}
