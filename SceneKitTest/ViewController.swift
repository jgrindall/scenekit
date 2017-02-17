
import UIKit
import SceneKit
import QuartzCore
import JavaScriptCore


class ViewController: UIViewController, SCNSceneRendererDelegate {
	
	var maxI:Int =		50;
	var maxJ:Int =		50;
	var size:Float =	12;
	var height:Float =	20;
	
	var sceneView:			SCNView!;
	var scene:				SCNScene!;
	var cameraNode:			SCNNode!;
	var base:				SCNNode!;
	var cameraOrbit:		SCNNode!;
	var lightNode:			SCNNode!;
	var originNode:			SCNNode!;
	var box:				SCNGeometry!;
	var boxNode:			SCNNode!;
	var gestureHandler:		GestureHandler!;
	var dispatchingValue:	DispatchingValue<Int>!;
	var patches:			Array<Patch>!;
	var turtles:			Array<Turtle>!;
	var consumer:			PMyClass!;
	
	func addScene(){
		self.sceneView = SCNView(frame: self.view.frame);
		self.view.addSubview(self.sceneView);
		self.sceneView.showsStatistics = true;
		self.sceneView.allowsCameraControl = false;
		self.sceneView.autoenablesDefaultLighting = false;
		self.sceneView.delegate = self;
		self.scene = SCNScene();
		self.scene.background.contents = UIImage(named: "bg.png");
		//self.scene.fogColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.75);
		//self.scene.fogStartDistance = 150;
		//self.scene.fogEndDistance = 300;
		//self.scene?.fogDensityExponent = 1.0;
		self.sceneView.scene = scene;
		self.patches = [Patch]();
		self.turtles = [Turtle]();
	}
	
	func addCamera(){
		self.cameraNode = SCNNode();
		self.cameraNode.camera = SCNCamera();
		self.cameraNode.camera!.xFov = 53;
		self.cameraNode.camera!.yFov  = 53;
		self.cameraNode.camera!.zFar = 2000;
		self.cameraNode.camera!.zNear = 0.01;
		self.cameraNode.position = SCNVector3(x: 0, y: 0, z: 1000);
		self.cameraOrbit = SCNNode();
		self.cameraOrbit.addChildNode(self.cameraNode);
		self.scene.rootNode.addChildNode(self.cameraOrbit);
		self.scene.rootNode.castsShadow = true;
		self.sceneView.pointOfView = self.cameraNode;
	}
	
	func updateHeight(){
		SCNTransaction.begin();
		let s:Float = Float(arc4random() % 30);
		if(self.box != nil){
			self.box.setValue(s, forKey: "h");
		}
		SCNTransaction.commit();
	}
	
	func addLights(){
		let ambientLight = SCNLight();
		ambientLight.type = SCNLight.LightType.ambient;
		ambientLight.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.75)
		let ambientLightNode = SCNNode()
		ambientLightNode.light = ambientLight;
		ambientLight.castsShadow = true;
		ambientLightNode.castsShadow = true;
		scene.rootNode.addChildNode(ambientLightNode);
		let cNode = SCNNode();
		cNode.transform = SCNMatrix4MakeRotation(Float(M_PI), 0, 0, 1);
		cNode.position = SCNVector3(Float(self.maxI)*self.size/2, 150, Float(self.maxI)*self.size/2)
		let spotLight = SCNLight();
		spotLight.color = UIColor.white;
		spotLight.type = SCNLight.LightType.spot;
		spotLight.spotInnerAngle = 20.0;
		spotLight.spotOuterAngle = 120.0;
		spotLight.castsShadow = true;
		let spotLightNode = SCNNode();
		spotLightNode.castsShadow = true;
		spotLightNode.light = spotLight;
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.red;
		cNode.addChildNode(spotLightNode);
		self.scene.rootNode.addChildNode(cNode);
	}
	
	func addGestures(){
		self.gestureHandler = GestureHandler(target: self, camera: self.cameraNode, lights:[]);
		self.sceneView.delegate = self.gestureHandler;
	}
	
	func edit(){
		let r0 = Float(arc4random_uniform(8)) - 4.0;
		let r1 = Float(arc4random_uniform(8)) - 4.0;
		for turtle in self.turtles {
			//turtle.position.setX(tree.position.x + r0);
			//turtle.position.setZ(tree.position.z + r1);
		}
		for patch in self.patches {
			//patch.getNode().eulerAngles = SCNVector3(0,0,0);
		}
	}
	
	func consumeNextCommand(){
		
	}
	
	func addTurtles(){
		var num:Int = 30;
		var size:Float = 20.0;
		var cx:Float = -Float(num) * size/2.0;
		var cz:Float = -Float(num) * size/2.0;
		for i in 0...num-1{
			for j in 0...num-1{
				let turtle:Turtle = Turtle(type: "turtle");
				turtle.pos(p: SCNVector3Make(Float(i)*size - cx, 8.0, Float(j)*size - cz));
				self.turtles.append(turtle);
				self.scene.rootNode.addChildNode(turtle.getNode());
			}
		}
	}
	
	func addPatches(){
		var num:Int = 30;
		var size:Float = 20.0;
		var cx:Float = -Float(num) * size/2.0;
		var cz:Float = -Float(num) * size/2.0;
		for i in 0...num-1{
			for j in 0...num-1{
				let patch:Patch = Patch(type: "grass");
				patch.pos(p: SCNVector3Make(Float(i)*size - cx, 0.0, Float(j)*size - cz));
				self.patches.append(patch);
				self.scene.rootNode.addChildNode(patch.getNode());
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
		self.addScene();
		self.addLights();
		self.addCamera();
		self.addGestures();
		self.addPatches();
		self.addTurtles();
		self.sceneView.isPlaying = true;
		let delayTime0 = DispatchTime.now() + Double(Int64(10 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: delayTime0) {
			Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:(#selector(ViewController.edit)), userInfo: nil, repeats: true);
		}
		self.consumer = MyClass();
		var cr = CodeRunner(consumer:self.consumer);
		cr.runFn(fnName: "myFn");
		print("WAIT0");
		var delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
		DispatchQueue.main.asyncAfter(deadline: delayTime) {
			print("WAIT1");
			cr.wait();
		}
		print("WAIT2");
		var delayTime1 = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
		DispatchQueue.main.asyncAfter(deadline: delayTime1) {
			print("WAIT3");
			cr.go();
		}
	}
}
