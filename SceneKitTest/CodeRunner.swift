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
		let consumer:@convention(block)(String, String)->Void = {type, data in
			if(type == "command"){
				self.consumer?.command(s: data);
			}
			else if(type == "message"){
				self.consumer?.message(s: data);
			}
			else if(type == "tapFingers"){
				self.consumer?.tapFingers();
			}
			return;
		}
		let buildPath = Bundle.main.path(forResource: "build", ofType: "js");
		let rjsPath = Bundle.main.path(forResource: "require", ofType: "js");
		do {
			let common = try String(contentsOfFile: buildPath!, encoding: String.Encoding.utf8);
			let rjs = try String(contentsOfFile: rjsPath!, encoding: String.Encoding.utf8);
			_ = self.context.evaluateScript(rjs);
			_ = self.context.evaluateScript(common);
			self.context.globalObject.setObject(unsafeBitCast(consumer, to: AnyObject.self), forKeyedSubscript: "consumer" as (NSCopying & NSObjectProtocol)!)
			self.context.globalObject.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol)!)
			self.context.exceptionHandler = { context, exception in
				print("JS Error: \(exception)");
			};
		}
		catch (let error) {
			print("Error while processing script file: \(error)");
		}
	}
	
	func run(fnName:String, arg:String) {
		print("run", fnName, arg);
		DispatchQueue.global(qos: .default).async {
			self.downloadGroup.enter();
			let filterFunction = self.context.objectForKeyedSubscript(fnName);
			_ = filterFunction?.call(withArguments: [arg]);
			self.downloadGroup.leave();
		}
	}
	
	func sleep() {
		let filterFunction = self.context.objectForKeyedSubscript("sleep");
		_ = filterFunction?.call(withArguments: nil);
	}
	
	func wake(){
		let filterFunction = self.context.objectForKeyedSubscript("wake");
		_ = filterFunction?.call(withArguments: nil);
	}
}

