import Foundation
import ReSwift

func bookmarksReducer(bookmarks: [String]?, action: Action) -> [String] {
	var newBookmarks = (bookmarks != nil) ? bookmarks! : [];
	switch action {
	case let action as BookmarkAction:
		newBookmarks.append(action.route);
		return newBookmarks;
	default:
		return newBookmarks;
	}
}
