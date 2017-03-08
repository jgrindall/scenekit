
import UIKit
import SceneKit
import QuartzCore
import JavaScriptCore
import ReSwift

public class ViewController: UIViewController, StoreSubscriber, PCodeConsumer, SCNSceneRendererDelegate {

	var logoSceneController:	LogoSceneViewController!;
	var hudController:			HUDViewController!;
	var consumer:				PCodeConsumer!;
	var codeRunner:				PCodeRunner!;
	var gestureHandler:			GestureHandler!;
	
	func consume(type: String, data: String) {
		self.logoSceneController.consume(type: type, data: data);
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
		let _ = self.hudController.events
		.addEventListener("start", handler: EventHandler(
			function: {
				(event: Event) in
				self.codeRunner.run(fnName: "run", arg: "rpt 100000 [fd 30 rt 1]");
		}))
		.addEventListener("stop", handler: EventHandler(
			function: {
				(event: Event) in
				self.codeRunner.end();
		}));
	}
	
	open func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		self.gestureHandler.onRender();
	}
		
	func addGestures(){
		self.gestureHandler = GestureHandler(target: self);
		let _ = self.gestureHandler.events
		.addEventListener("start", handler: EventHandler(
			function: {
				(event: Event) in
				Singleton.sharedInstance.store.dispatch(GestureStatusAction(status: true));
				self.codeRunner.sleep();
			})
		)
		.addEventListener("end", handler: EventHandler(
			function: {
				(event: Event) in
				Singleton.sharedInstance.store.dispatch(GestureStatusAction(status: false));
				self.codeRunner.wake();
			})
		)
		.addEventListener("transform", handler: EventHandler(
			function: {
				(event: Event) in
				self.logoSceneController.onTransform(t:event.data as! SCNMatrix4);
			})
		);
	}
	
	public func newState(state: SubState) {
		//print("newState", state);
	}
	
	private func addCode(){
		self.codeRunner = CodeRunner(fileNames:["require", "build"], consumer:self);
		let _ = self.codeRunner.events?.addEventListener("change:status", handler: EventHandler(
			function: {
				(event: Event) in
				print(event);
				Singleton.sharedInstance.store.dispatch(CodeStatusAction(status: event.data as! String));
			})
		);
		Singleton.sharedInstance.store.dispatch(CodeStatusAction(status: "ready"));
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad();
		Singleton.sharedInstance.store.subscribe(self) {
			($0.repositories)
		}
		self.addLogo();
		self.addHUD();
		self.addGestures();
		self.addCode();
	}
}


