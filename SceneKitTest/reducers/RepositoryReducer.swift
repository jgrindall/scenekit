import ReSwift

func repositoriesReducer(repositories: SubState?, action: Action) -> SubState? {
	switch action {
	case let action as RepositoriesAction:
		return action.repositories
	default:
		return []
	}
}
