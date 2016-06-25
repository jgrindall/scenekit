
import UIKit
import SceneKit
import QuartzCore

class ViewController: UIViewController, SCNSceneRendererDelegate {
	
	var sceneView:SCNView!;
	var scene:SCNScene!;
	var cameraNode:SCNNode!;
	var cubeNode:SCNNode!;
	var lightNode:SCNNode!;
	var newNode:SCNNode!;
	
	var m:CInt = 2;
	var n:CInt = 2;
	
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
		let path = NSBundle.mainBundle().pathForResource("wave", ofType: "shader");
		let path2 = NSBundle.mainBundle().pathForResource("wave2", ofType: "shader");
		let imgPath = NSBundle.mainBundle().pathForResource("rock", ofType: "jpg");
		let img = UIImage(contentsOfFile: imgPath!);
		let imgPath2 = NSBundle.mainBundle().pathForResource("rock2", ofType: "jpg");
		let img2 = UIImage(contentsOfFile: imgPath2!);
		let mProp = SCNMaterialProperty(contents: img!);
		let mProp2 = SCNMaterialProperty(contents: img2!);
		let modifier = try? String(contentsOfFile: path!)
		let modifier2 = try? String(contentsOfFile: path2!)
		newGeometry.shaderModifiers = [
			SCNShaderModifierEntryPointSurface: modifier2!,
			SCNShaderModifierEntryPointGeometry: modifier!
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
		let constraint = SCNLookAtConstraint(target: self.newNode)
		constraint.gimbalLockEnabled = true;
		self.cameraNode.constraints = [constraint];
		self.lightNode.constraints = [constraint];
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.addScene();
		self.addLights();
		self.addGeom();
		self.constrain();
		self.sceneView.playing = true;
		
	}
}



