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

protocol PGestureDelegate{
	func onStart();
	func onFinished();
	func onTransform(t:SCNMatrix4);
}

