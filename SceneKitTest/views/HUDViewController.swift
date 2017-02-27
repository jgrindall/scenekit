
import UIKit
import SceneKit
import QuartzCore
import JavaScriptCore

public class HUDViewController: UIViewController {
	
	var button:				UIButton!;
	var button1:			UIButton!;
	var label:				UILabel!;
	
	override public func viewDidLoad() {
		super.viewDidLoad();
		self.button = UIButton(type: UIButtonType.system);
		self.button.setTitle("start", for: .normal);
		self.button.setTitleColor(UIColor.black, for: UIControlState.normal);
		self.view.addSubview(self.button);
		self.button.frame = CGRect(x: 50.0, y: 100.0, width: 100.0, height: 50.0);
		self.button.addTarget(self, action: #selector(HUDViewController.buttonUp), for: UIControlEvents.touchUpInside);
		self.button.backgroundColor = UIColor.red;
		
		self.button1 = UIButton(type: UIButtonType.system);
		self.button1.setTitle("end", for: .normal);
		self.button1.setTitleColor(UIColor.black, for: UIControlState.normal);
		self.view.addSubview(self.button1);
		self.button1.frame = CGRect(x: 200.0, y: 100.0, width: 100.0, height: 50.0);
		self.button1.addTarget(self, action: #selector(HUDViewController.buttonUp1), for: UIControlEvents.touchUpInside);
		self.button1.backgroundColor = UIColor.green;
		
		self.label = UILabel(frame: CGRect(x: 450.0, y: 100.0, width: 200.0, height: 50.0));
		self.view.addSubview(self.label);
		self.label.text = "new";
	}
	
	func buttonUp(){
		print("run");
		//self.codeRunner.run(fnName: "run", arg: "rpt 100000 [fd 30 rt 1]");
	};
	
	func buttonUp1(){
		print("stop");
		//self.codeRunner.end();
	};
	
	func onStart(){
		//self.codeRunner.sleep();
	}
	
	func onFinished(){
		//self.codeRunner.wake();
	}
	
	func onStatusChange(status:String){
		print("status", status);
		DispatchQueue.main.async { [unowned self] in
			self.label.text = status;
		}
	}
}
