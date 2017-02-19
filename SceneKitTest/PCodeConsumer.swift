
import Foundation
import SceneKit
import QuartzCore
import JavaScriptCore
import UIKit

@objc
protocol PCodeConsumer : JSExport {

	func consume(type:String, data:String);

}

