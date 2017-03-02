
import UIKit
import SceneKit
import QuartzCore
import JavaScriptCore
import ReSwift

typealias Bookmark = (route: String, data: Any?)

struct State: StateType {
	var repositories: [Int]?
	var bookmarks: [Bookmark]?
}

