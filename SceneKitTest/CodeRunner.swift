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
				print("log " + message);
			}
			self.context.exceptionHandler = { context, exception in
				print("JS Error: \(exception)");
			};
			self.context.globalObject.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol)!)
			self.loadFiles(fileNames: fileNames);
		};
	}
	
	func setConsumer(consumer:PCodeConsumer, name:String) -> PCodeRunner{
		self._consumer = consumer;
		let lockedConsumerBlock:@convention(block)(String, String)->Void = {type, data in
			self.mutexLock.locked {
				self._consumer.consume(type: type, data:data);
			}
		}
		serialQueue.sync{
			let castBlock:Any! = unsafeBitCast(lockedConsumerBlock, to: AnyObject.self);
			self.context.globalObject.setObject(castBlock, forKeyedSubscript: name as (NSCopying & NSObjectProtocol)!);
		}
		return self;
	}
	
	func run(fnName:String, arg:String) {
		serialQueue.async{
			let fn = self.context.objectForKeyedSubscript(fnName);
			_ = fn?.call(withArguments: [arg]);
		}
	}
	
	func sleep() {
		self.mutexLock.lock();
	}
	
	func wake(){
		self.mutexLock.unlock();
	}
}

