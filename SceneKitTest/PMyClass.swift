
import Foundation
import SceneKit
import QuartzCore
import JavaScriptCore
import UIKit

@objc
protocol PMyClass : JSExport {
	func getItem(key: String) -> String?;
	func command(s:String);
	func message(s:String);
	func tapFingers();
	func setItem(key: String, data: String);
	func myFunctionParam1(param1 : String, param2 : String, param3 : String);
}

