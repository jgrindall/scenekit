
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
		print("command! ", s);
		self.target?.command(s: s);
	}
	func message(s: String) {
		print("message! ", s);
	}
	func tapFingers(){
		print("tiptap");
	}
}
