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
	let downloadGroup = DispatchGroup();
	
	override init(){
		super.init();
		self.myClass = MyClass();
		self.context = JSContext();
		
		let consoleLog: @convention(block) (String) -> Void = { message in
			print("console.log: " + message)
		}
		
		let buildPath = Bundle.main.path(forResource: "build", ofType: "js");
		let rjsPath = Bundle.main.path(forResource: "require", ofType: "js");
		do {
			let common = try String(contentsOfFile: buildPath!, encoding: String.Encoding.utf8);
			let rjs = try String(contentsOfFile: rjsPath!, encoding: String.Encoding.utf8);
			_ = self.context.evaluateScript(rjs);
			_ = self.context.evaluateScript(common);
			self.context.globalObject.setObject(self.myClass, forKeyedSubscript: "objectwrapper" as (NSCopying & NSObjectProtocol)!)
			self.context.globalObject.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "_consoleLog" as (NSCopying & NSObjectProtocol)!)
			self.context.exceptionHandler = { context, exception in
				print("JS Error: \(exception)");
			};
		}
		catch (let error) {
			print("Error while processing script file: \(error)");
		}
	}
	
	func outputReceived(a:Int){
		print("output");
		print(a);
	}
	
	func runFn(fnName:String) {
		print("run");
		DispatchQueue.global(qos: .default).async {
			self.downloadGroup.enter();
			let filterFunction = self.context.objectForKeyedSubscript(fnName);
			_ = filterFunction?.call(withArguments: nil);
			print("done");
			self.downloadGroup.leave();
		}
	}
	
	func wait() {
		print("w1");
		let filterFunction = self.context.objectForKeyedSubscript("pause");
		_ = filterFunction?.call(withArguments: nil);
		print("w2");
	}
	
	func go(){
		print("g1");
		let filterFunction = self.context.objectForKeyedSubscript("unpause");
		_ = filterFunction?.call(withArguments: nil);
		print("g2");
	}
}

