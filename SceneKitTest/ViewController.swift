
import UIKit
import SceneKit
import QuartzCore
import JavaScriptCore
import ReSwift

public class ViewController: UIViewController, StoreSubscriber, PCodeConsumer, PGestureDelegate, PCodeListener, SCNSceneRendererDelegate {

	var logoSceneController:	LogoSceneViewController!;
	var hudController:			HUDViewController!;
	var consumer:				PCodeConsumer!;
	var codeRunner:				PCodeRunner!;
	var gestureHandler:			GestureHandler!;
	
	func onStart(){
		self.codeRunner.sleep();
	}
	
	func onFinished(){
		self.codeRunner.wake();
	}
	
	func _command(data:String){
		let d:[String:Any] = ImageUtils.convertToDictionary(text: data)!;
		let name: String = (d["name"] as? String)!;
		let amt:Float = (d["amount"] as? Float)!;
		if(name == "fd"){
			//for turtle in self.turtles {
				//turtle.fd(n: amt);
			//}
		}
		else if(name == "rt"){
			//for turtle in self.turtles {
				//turtle.rt(n: amt);
			//}
		}
	}
	
	func updateAll(){
		//for turtle in self.turtles {
			//turtle.update();
		//}
	}
	
	
	func command(data:String){
		self._command(data: data);
		SCNTransaction.begin();
		self.updateAll();
		SCNTransaction.commit();
	}
	
	func consume(type: String, data: String) {
		if(type == "message"){
			print(data);
		}
		else if(type == "command"){
			self.command(data:data);
		}
	}
	
	func onStatusChange(status:String){
		print("status", status);
		DispatchQueue.main.async { [unowned self] in
			//self.label.text = status;
		}
	}
	
	func addLogo(){
		self.logoSceneController = LogoSceneViewController();
		self.logoSceneController.view.frame = self.view.frame;
		self.view.addSubview(self.logoSceneController.view);
		self.addChildViewController(self.logoSceneController);
		self.logoSceneController.didMove(toParentViewController: self);
		self.logoSceneController.getSceneView().delegate = self;
	}
	
	func addHUD(){
		self.hudController = HUDViewController();
		self.hudController.view.frame = self.view.frame;
		self.view.addSubview(self.hudController.view);
		self.addChildViewController(self.hudController);
		self.hudController.didMove(toParentViewController: self);
	}
	
	open func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		self.gestureHandler.onRender();
	}
		
	func addGestures(){
		self.gestureHandler = GestureHandler(target: self, delegate: self);
	}
	
	func onTransform(t:SCNMatrix4){
		self.logoSceneController.onTransform(t:t);
	}
	
	public func newState(state: State) {
		print("s", state);
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad();
		
		Singleton.sharedInstance.store.subscribe(self);
		self.addLogo();
		self.addHUD();
		
		self.addGestures();
		//self.updateAll();
		self.codeRunner = CodeRunner(fileNames:["require", "build"], consumer:self);
		self.codeRunner.onStatusChange(listener: self);
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			Singleton.sharedInstance.store.dispatch(BookmarkAction(route: "123"));
		}
		
		
		
	}
}
