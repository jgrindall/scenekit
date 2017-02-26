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
class CodeRunner : NSObject, PCodeRunner {
	
	var context: JSContext!
	let serialQueue = DispatchQueue(label: "codeRunnerSerialQueue" + UUID().uuidString);
	let mutexLock = Mutex();
	var _consumer:PCodeConsumer!;
	var _status:DispatchingValue<String> = DispatchingValue("new");

	enum CodeRunnerError : Error {
		case RuntimeError(String)
	}
	
	required init(fileNames:[String], consumer:PCodeConsumer){
		super.init();
		self.makeContext(fileNames: fileNames);
		self.loadFiles(fileNames: fileNames);
		self._consumer = consumer;
		self._status.value = "ready";
	}
	
	private func loadFile(fileName:String){
		do {
			let path:String = Bundle.main.path(forResource: fileName, ofType: "js")!;
			let contents = try String(contentsOfFile:path, encoding: String.Encoding.utf8);
			_ = self.context.evaluateScript(contents);
		}
		catch (let error) {
			print("Error while processing script file: \(error)");
		}
	}
	
	private func loadFiles(fileNames:[String]){
		for fileName:String in fileNames{
			self.loadFile(fileName:fileName);
		}
	}
	
	private func makeContext(fileNames:[String]){
		self.context = JSContext(virtualMachine: JSVirtualMachine());
		let consoleLog: @convention(block) (String) -> Void = { message in
			print("console.log " + message);
		}
		self.context.exceptionHandler = { context, exception in
			print("error: \(exception)");
		};
		self.context.globalObject.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol)!)
	}
	
	private func bindConsumer(){
		let lockedConsumerBlock:@convention(block)(String, String) ->Void = {type, data in
			let allowedStates:[String] = ["running", "pausing", "paused", "waking"];
			if(allowedStates.index(of: self._status.value) == nil){
				print("broken...", self._status.value);
			}
			else{
				self.mutexLock.locked {
					if(self._status.value == "running" && self.hasConsumer()){
						if(type == "end"){
							self._status.value = "ready";
						}
						else{
							self._consumer.consume(type: type, data:data);
						}
					}
				}
			}
		}
		let castBlock:Any! = unsafeBitCast(lockedConsumerBlock, to: AnyObject.self);
		self.context.globalObject.setObject(castBlock, forKeyedSubscript: "consumer" as (NSCopying & NSObjectProtocol)!);
	}
	
	private func unbindConsumer(){
		self.context.globalObject.setObject(nil, forKeyedSubscript: "consumer" as (NSCopying & NSObjectProtocol)!);
	}
	
	func hasConsumer() -> Bool{
		let c = self.context.globalObject.objectForKeyedSubscript("consumer");
		if(c == nil || c?.toString() == "undefined"){
			return false;
		}
		return true;
	}
	
	func run(fnName:String, arg:String) {
		if(self._status.value == "ready"){
			self._status.value = "about to run";
			if(!self.hasConsumer()){
				self.bindConsumer();
			}
			serialQueue.async{
				if(self._status.value == "about to run"){
					self._status.value = "running";
				}
				let fn = self.context.objectForKeyedSubscript(fnName);
				_ = fn?.call(withArguments: [arg]);
			}
		}
	}
	
	func onStatusChange(listener:PCodeListener){
		let handler = EventHandler(function: {
		    (event: Event) in
			listener.onStatusChange(status:self._status.value);
		});
		self._status.addEventListener("change", handler: handler);
	}
	
	func end(){
		let fn = self.context.objectForKeyedSubscript("end");
		_ = fn?.call(withArguments: []);
		self.unbindConsumer();
		self._status.value = "ready";
	}
	
	func sleep(){
		if(self._status.value == "running"){
			self._status.value = "pausing";
			self.mutexLock.lock();
			self._status.value = "paused";
		}
	}
	
	func wake(){
		if(self._status.value == "paused"){
			self._status.value = "waking";
			self.mutexLock.unlock();
			self._status.value = "running";
		}
	}
}

