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

class Canceller{
	var _shouldCancel = false;
	func shouldCancel() -> Bool{
		return self._shouldCancel;
	}
	func setShouldCancel(s:Bool) {
		self._shouldCancel = s;
	}
}


@objc
class CodeRunner : NSObject, PCodeRunner {
	
	var context: JSContext!
	var vm: JSVirtualMachine!
	let serialQueue = DispatchQueue(label: "codeSerialQueue");
	let downloadGroup = DispatchGroup();
	var consumer:PCodeConsumer?
	let semaphore = DispatchSemaphore(value: 1);
	let tapCondition = NSCondition();
	var seenTap:Bool = true
	var c = Canceller();
	
	let m = Mutex()
	
	
	
	
	required init(consumer:PCodeConsumer){
		super.init();
		self.consumer = consumer;
		self.makeContext();
	}
	
	func wait() {
		print("wait", self.seenTap);
		self.tapCondition.lock()
		while (!seenTap) {
			self.tapCondition.wait()
		}
		self.tapCondition.unlock()
	}
	
	func notify() {
		self.tapCondition.lock()
		self.tapCondition.signal()
		self.tapCondition.unlock()
	}

	
	func makeContext(){
		serialQueue.async{
			self.vm = JSVirtualMachine();
			self.context = JSContext(virtualMachine: self.vm);
			let consoleLog: @convention(block) (String) -> Void = { message in
				print("log " + message);
			}
			let consumer:@convention(block)(String, String)->Void = {type, data in
				self.m.locked {
					if(type == "command"){
						self.consumer?.command(s: data);
					}
					else if(type == "message"){
						self.consumer?.message(s: data);
					}
					else if(type == "tapFingers"){
						self.consumer?.tapFingers();
					}
				}
			}
			let buildPath = Bundle.main.path(forResource: "build", ofType: "js");
			let rjsPath = Bundle.main.path(forResource: "require", ofType: "js");
			do {
				let rjs = try String(contentsOfFile: rjsPath!, encoding: String.Encoding.utf8);
				let common = try String(contentsOfFile: buildPath!, encoding: String.Encoding.utf8);
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
		};
	}
	
	func run(fnName:String, arg:String) {
		serialQueue.async{
			let filterFunction = self.context.objectForKeyedSubscript(fnName);
			_ = filterFunction?.call(withArguments: [arg]);
		}
		print("run", fnName, arg);
	}
	
	func sleep() {
		self.m.lock();
	}
	
	func wake(){
		self.m.unlock();
	}
}

