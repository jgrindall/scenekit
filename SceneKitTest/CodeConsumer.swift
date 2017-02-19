
import Foundation
import SceneKit
import QuartzCore
import JavaScriptCore
import UIKit

@objc
public class CodeConsumer: NSObject, PCodeConsumer {
	
	var target:ViewController?;
	
	required public init(target:ViewController){
		self.target = target;
		super.init();
	}
	func command(s:String){
		//semaphore.wait(timeout: DispatchTime.distantFuture);
		print("command! ", s);
		//Thread.sleep(forTimeInterval: 1);
		self.target?.command(s: s);
	}
	func message(s: String) {
		print("message! ", s);
	}
	func tapFingers(){
		print("tiptap");
	}
}
