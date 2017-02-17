
import Foundation
import SceneKit
import QuartzCore
import JavaScriptCore
import UIKit

@objc
public class MyClass: NSObject, PMyClass {
	override init(){
		super.init();
	}
	func getItem(key: String) -> String? {
		return "String value";
	}
	func command(s:String){
		print("command! ");
	}
	func message(s: String) {
		print("message! ");
	}
	
	func tapFingers(){
		print("tiptap");
	}
	
	func setItem(key: String, data: String) {
		print("Set key");
	}
	func myFunctionParam1(param1 : String, param2 : String, param3 : String){
		print("fn");
	}
}
