//
//  ImageUtils
//  SceneKitTest
//
//  Created by John on 25/06/2016.
//
//

import Foundation
import SceneKit
import QuartzCore
import JavaScriptCore
import UIKit

@objc
protocol PCodeRunner {
	
	init(consumer:PCodeConsumer);
	func run(fnName:String, arg:String);
	func sleep() ;
	func wake();
}

