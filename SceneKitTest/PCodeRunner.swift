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
	
	init(fileNames:[String]);
	func run(fnName:String, arg:String);
	func setConsumer(consumer:PCodeConsumer, name:String) -> PCodeRunner;
	func sleep() ;
	func wake();
}

