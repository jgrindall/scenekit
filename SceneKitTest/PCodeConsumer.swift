
import Foundation
import SceneKit
import QuartzCore
import JavaScriptCore
import UIKit

@objc
protocol PCodeConsumer : JSExport {

	init(target:ViewController);
	func command(s:String);
	func message(s:String);
	func tapFingers();

}

