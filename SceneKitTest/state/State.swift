
import UIKit
import SceneKit
import QuartzCore
import JavaScriptCore
import ReSwift

public struct State: StateType {
	var repositories: SubState = [1, 2, 3];
	var bookmarks: [String] = ["a", "b", "c"];
	var status:RState = false;
	var codeStatus:CStatus = "new";
	var gStatus:GState = false;
}

