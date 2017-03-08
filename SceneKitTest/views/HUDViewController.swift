
import UIKit
import SceneKit
import QuartzCore
import JavaScriptCore
import ReSwift
import RxSwift

public class HUDViewController: UIViewController, StoreSubscriber {
	
	public typealias StoreSubscriberStateType = State;
	
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
	
	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated);
		Singleton.sharedInstance.store.subscribe(self);
	}
	
	override public func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated);
	}
	
	public func newState(state: State) {
		let gStatus = state.gStatus;
		DispatchQueue.main.async { [unowned self] in
			self.label.text =			state.codeStatus;
			self.button.isEnabled =		!gStatus;
			self.button.alpha =			gStatus ? 0.3 : 1;
			self.button1.isEnabled =	!gStatus;
			self.button1.alpha =		gStatus ? 0.3 : 1;
		}
	}
	
	func buttonUp(){
		print("run");
		//self.codeRunner.run(fnName: "run", arg: "rpt 100000 [fd 30 rt 1]");
	};
	
	func buttonUp1(){
		print("stop");
		//self.codeRunner.end();
	};
	
}
