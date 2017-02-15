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
protocol JavaScriptMethods : JSExport {
	func getItem(key: String) -> String?;
	func f();
	func p();
	func setItem(key: String, data: String);
	func myFunctionParam1(param1 : String, param2 : String, param3 : String);
}

@objc
public class MyClass: NSObject, JavaScriptMethods {
	override init(){
		super.init();
	}
	func getItem(key: String) -> String? {
		return "String value";
	}
	func f(){
		print("SetF");
	}
	
	func p(){
		print("pppp");
	}
	
	func setItem(key: String, data: String) {
		print("Set key");
	}
	func myFunctionParam1(param1 : String, param2 : String, param3 : String){
		print("fn");
	}
}
