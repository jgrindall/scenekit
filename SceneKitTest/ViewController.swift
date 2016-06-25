
import UIKit
import SceneKit
import QuartzCore

class ViewController: UIViewController, SCNSceneRendererDelegate {
	
	var sceneView:SCNView!;
	var scene:SCNScene!;
	var cameraNode:SCNNode!;
	var newNode:SCNNode!;
	var lightNode:SCNNode!;
	var originNode:SCNNode!;
	
	var m:CInt = 5;
	var n:CInt = 4;
	
	func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		self.posCamera(time);
	}
	
	func posCamera(t:Double){
		let r:Float = 10.0;
		let x = r * sinf(Float(t/10.0));
		let z = r * cosf(Float(t/10.0));
		self.cameraNode.position = SCNVector3Make(x, r, z);
	}
	
	func addScene(){
		self.sceneView = SCNView(frame: self.view.frame);
		self.sceneView.delegate = self;
		self.view.addSubview(self.sceneView)
		self.sceneView.showsStatistics = true
		self.scene = SCNScene()
		self.sceneView.scene = scene;
		let camera = SCNCamera()
		self.cameraNode = SCNNode()
		self.cameraNode.camera = camera;
		self.posCamera(0.5);
		self.scene.rootNode.addChildNode(self.cameraNode);
	}
	
	func addPlane(){
		let planeGeometry = SCNPlane(width: 100.0, height: 100.0);
		let planeNode = SCNNode(geometry: planeGeometry)
		planeNode.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90.0), 0, 0);
		planeNode.position = SCNVector3Make(0, -0.5, 0);
		let greenMaterial = SCNMaterial();
		greenMaterial.diffuse.contents = UIColor.grayColor();
		planeGeometry.materials = [greenMaterial];
		scene.rootNode.addChildNode(planeNode);
	}
	
	func addGeom2(){
		let blockGeometry:SCNGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0);
		let blockNode = SCNNode(geometry: blockGeometry);
		let mProp = Assets.getRock();
		let mProp2 = Assets.getRock2();
		let modifier = Assets.getModifier();
		let modifier2 = Assets.getModifier2();
		for i in 0 ..< self.m{
			for j in 0 ..< self.n {
				let node = blockNode.clone();
				node.geometry!.shaderModifiers = [
					SCNShaderModifierEntryPointSurface: modifier2,
					SCNShaderModifierEntryPointGeometry: modifier
				];
				node.geometry!.setValue(mProp, forKey: "tex");
				node.geometry!.setValue(mProp2, forKey: "tex2");
				node.position = SCNVector3Make(Float(i), 1.3, Float(j));
				scene.rootNode.addChildNode(node);
			}
		}
	}
	
	func addGeom(){
		let newGeometry:SCNGeometry = GeomUtils.makeTopology(self.m, n: self.n);
		let planeGeometry = SCNPlane(width: 100.0, height: 100.0);
		let planeNode = SCNNode(geometry: planeGeometry)
		planeNode.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90.0), 0, 0);
		planeNode.position = SCNVector3Make(0, -0.5, 0);
		let redMaterial = SCNMaterial();
		redMaterial.diffuse.contents = UIColor.redColor();
		let greenMaterial = SCNMaterial();
		greenMaterial.diffuse.contents = UIColor.grayColor();
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.blueColor();
		newGeometry.materials = [blueMaterial, greenMaterial, redMaterial];
		self.newNode = SCNNode(geometry: newGeometry);
		self.newNode.position = SCNVector3Make(-1.0, 1.3, -0.6);
		scene.rootNode.addChildNode(planeNode);
		scene.rootNode.addChildNode(newNode);
		let mProp = Assets.getRock();
		let mProp2 = Assets.getRock2();
		let modifier = Assets.getModifier();
		let modifier2 = Assets.getModifier2();
		newGeometry.shaderModifiers = [
			SCNShaderModifierEntryPointSurface: modifier2,
			SCNShaderModifierEntryPointGeometry: modifier
		];
		newGeometry.setValue(mProp, forKey: "tex");
		newGeometry.setValue(mProp2, forKey: "tex2");
	}
	
	func addLights(){
		let ambientLight = SCNLight();
		ambientLight.type = SCNLightTypeAmbient;
		ambientLight.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		let ambientLightNode = SCNNode()
		ambientLightNode.light = ambientLight
		scene.rootNode.addChildNode(ambientLightNode)
		let light = SCNLight();
		light.type = SCNLightTypeSpot;
		light.spotInnerAngle = 60.0;
		light.spotOuterAngle = 120.0;
		light.castsShadow = true;
		self.lightNode = SCNNode()
		self.lightNode.light = light;
		self.lightNode.position = SCNVector3Make(2.0, 1.5, 1.5);
		self.scene.rootNode.addChildNode(self.lightNode);
	}
	
	func constrain(){
		self.originNode = SCNNode();
		self.originNode.position = SCNVector3Make(0.0, 0.0, 0.0);
		let constraint = SCNLookAtConstraint(target: self.originNode);
		constraint.gimbalLockEnabled = true;
		self.cameraNode.constraints = [constraint];
		self.lightNode.constraints = [constraint];
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.addScene();
		self.addLights();
		self.addPlane();
		self.addGeom();
		self.constrain();
		self.sceneView.playing = true;
		
	}
}



