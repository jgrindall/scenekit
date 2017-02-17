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
	let serialQueue = DispatchQueue(label: "queuename");
	let downloadGroup = DispatchGroup();
	var consumer:PMyClass?
	
	init(consumer:PMyClass){
		super.init();
		self.consumer = consumer;
		self.makeContext();
	}
	
	func makeContext(){
		self.context = JSContext();
		let consoleLog: @convention(block) (String) -> Void = { message in
			print("log " + message);
		}
		
		let buildPath = Bundle.main.path(forResource: "build", ofType: "js");
		let rjsPath = Bundle.main.path(forResource: "require", ofType: "js");
		do {
			let common = try String(contentsOfFile: buildPath!, encoding: String.Encoding.utf8);
			let rjs = try String(contentsOfFile: rjsPath!, encoding: String.Encoding.utf8);
			_ = self.context.evaluateScript(rjs);
			_ = self.context.evaluateScript(common);
			print(self.consumer);
			self.context.globalObject.setObject(self.consumer, forKeyedSubscript: "_consumer" as (NSCopying & NSObjectProtocol)!)
			self.context.globalObject.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "_consoleLog" as (NSCopying & NSObjectProtocol)!)
			self.context.exceptionHandler = { context, exception in
				print("JS Error: \(exception)");
			};
		}
		catch (let error) {
			print("Error while processing script file: \(error)");
		}
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

