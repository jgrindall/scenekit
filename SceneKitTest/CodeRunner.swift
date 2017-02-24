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
	var _running = false;
	var _bound = false;

	enum CodeRunnerError : Error {
		case RuntimeError(String)
	}
	
	required init(fileNames:[String]){
		super.init();
		self.makeContext(fileNames: fileNames);
	}
	
	private func loadFile(fileName:String){
		do {
			let contents = try String(contentsOfFile: Bundle.main.path(forResource: fileName, ofType: "js")!, encoding: String.Encoding.utf8);
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
	
	func makeContext(fileNames:[String]){
		serialQueue.sync{
			self.context = JSContext();
			let consoleLog: @convention(block) (String) -> Void = { message in
				print("console.log " + message);
			}
			self.context.exceptionHandler = { context, exception in
				print("error: \(exception)");
			};
			self.context.globalObject.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol)!)
			self.loadFiles(fileNames: fileNames);
		};
	}
	
	func bindConsumer(){
		let lockedConsumerBlock:@convention(block)(String, String) ->Void = {type, data in
			if(self._consumer == nil || !self._bound || !self._running){
				print("broken");
			}
			else{
				self.mutexLock.locked {
					if(self._consumer != nil){
						self._consumer.consume(type: type, data:data);
					}
				}
			}
		}
		serialQueue.sync{
			print("bind1");
			let castBlock:Any! = unsafeBitCast(lockedConsumerBlock, to: AnyObject.self);
			self.context.globalObject.setObject(castBlock, forKeyedSubscript: "consumer" as (NSCopying & NSObjectProtocol)!);
		}
		print("bind2");
		self._bound = true;
	}
	
	func unbindConsumer(){
		print("unbind");
		self.context.globalObject.setObject(nil, forKeyedSubscript: "consumer" as (NSCopying & NSObjectProtocol)!);
		self._bound = false;
	}
	
	func setConsumer(consumer:PCodeConsumer) -> PCodeRunner{
		if(self._consumer == nil){
			self._consumer = consumer;
		}
		return self;
	}
	
	func checkBind(){
		if(self._consumer != nil && !self._bound){
			print("run & bind!");
			self.bindConsumer();
		}
	}
	
	func run(fnName:String, arg:String) {
		if(!self._running){
			self.checkBind();
			serialQueue.async{
				self._running = true;
				let fn = self.context.objectForKeyedSubscript(fnName);
				_ = fn?.call(withArguments: [arg]);
			}
		}
	}
	
	func end(){
		let fn = self.context.objectForKeyedSubscript("end");
		_ = fn?.call(withArguments: []);
		self.unbindConsumer();
		self._running = false;
	}
	
	func sleep(){
		if(self._running && self._consumer != nil && self._bound){
			self.mutexLock.lock();
			self._running = false;
		}
	}
	
	func wake(){
		if(!self._running && self._consumer != nil && self._bound){
			self.mutexLock.unlock();
			self._running = true;
		}
	}
}

