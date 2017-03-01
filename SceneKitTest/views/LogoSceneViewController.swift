
import UIKit
import SceneKit
import QuartzCore
import JavaScriptCore

public class LogoSceneViewController: UIViewController {
	
	private var base:					BaseScene!;
	private var patches:				Array<Patch>!;
	private var turtles:				Array<Turtle>!;
	
	override public func viewDidLoad() {
		super.viewDidLoad();
		self.base = BaseScene(frame:self.view.frame);
		self.view.addSubview(self.base.getSceneView());
		self.patches = [Patch]();
		self.turtles = [Turtle]();
		self.addPatches();
		self.addTurtles();
		self.base.play();
	}
	
	func getRootNode() -> SCNNode{
		return self.base.getRootNode();
	}
	
	func getSceneView() -> SCNView{
		return self.base.getSceneView();
	}
	
	func onTransform(t:SCNMatrix4){
		self.base.onTransform(t:t);
	}
	
	func addTurtles(){
		let num:Int = 8;
		let size:Float = 40.0;
		let cx:Float = -Float(num) * size/2.0;
		let cz:Float = -Float(num) * size/2.0;
		for i in 0...num-1{
			for j in 0...num-1{
				let turtle:Turtle = Turtle(type: "turtle");
				turtle.pos(p: SCNVector3Make(Float(i)*size - cx, 8.0, Float(j)*size - cz));
				self.turtles.append(turtle);
				self.getRootNode().addChildNode(turtle.getNode());
			}
		}
	}
	
	func addPatches(){
		let num:Int = 8;
		let size:Float = 40.0;
		let cx:Float = -Float(num) * size/2.0;
		let cz:Float = -Float(num) * size/2.0;
		for i in 0...num-1{
			for j in 0...num-1{
				let patch:Patch = Patch(type: "grass");
				patch.pos(p: SCNVector3Make(Float(i)*size - cx, 0.0, Float(j)*size - cz));
				self.patches.append(patch);
				self.getRootNode().addChildNode(patch.getNode());
			}
		}
	}
}
