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
class CodeRunner : NSObject {
	
	var context: JSContext!
	var myClass: MyClass!;
	let serialQueue = DispatchQueue(label: "queuename");
	
	override init(){
		super.init();
		self.myClass = MyClass();
		serialQueue.async {
			self.context = JSContext();
			let commonJSPath = Bundle.main.path(forResource: "common", ofType: "js");
			do {
				let common = try String(contentsOfFile: commonJSPath!, encoding: String.Encoding.utf8);
				_ = self.context.evaluateScript(common);
				self.context.globalObject.setObject(self.myClass, forKeyedSubscript: "objectwrapper" as (NSCopying & NSObjectProtocol)!)
				self.context.exceptionHandler = { context, exception in
					print("JS Error: \(exception)");
				};
			}
			catch (let error) {
				print("Error while processing script file: \(error)");
			}
		}
	}
	
	func outputReceived(a:Int){
		print("output");
		print(a);
	}
	
	func runFn(fnName:String) {
		print("run");
		serialQueue.async {
			let filterFunction = self.context.objectForKeyedSubscript(fnName);
			print(filterFunction);
			_ = filterFunction?.call(withArguments: nil);
			print("done");
		}
	}
	
	func wait(duration: Double) {
		serialQueue.suspend();
	}
}
