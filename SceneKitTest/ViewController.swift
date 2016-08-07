
import UIKit
import SceneKit
import QuartzCore

class ViewController: UIViewController, SCNSceneRendererDelegate {
	
	var maxI:CInt =		10;
	var maxJ:CInt =		10;
	var size:Float =	8.0;
	
	var sceneView:		SCNView!;
	var scene:			SCNScene!;
	var cameraNode:		SCNNode!;
	var base:			SCNNode!;
	var terrain:		Terrain!;
	var cameraOrbit:	SCNNode!;
	var lightNode:		SCNNode!;
	var originNode:		SCNNode!;
	var gestureHandler:	GestureHandler!;
	
	func addScene(){
		self.sceneView = SCNView(frame: self.view.frame);
		self.view.addSubview(self.sceneView);
		self.sceneView.showsStatistics = true;
		self.sceneView.allowsCameraControl = true;
		self.sceneView.autoenablesDefaultLighting = true;
		self.sceneView.delegate = self;
		self.scene = SCNScene();
		self.sceneView.scene = scene;
	}
	
	func addCamera(){
		self.cameraNode = SCNNode();
		self.cameraNode.camera = SCNCamera();
		self.cameraNode.camera!.xFov = 60;
		self.cameraNode.camera!.yFov  = 60;
		self.cameraNode.camera!.zFar = 1000;
		self.cameraNode.camera!.zNear = 0.01;
		self.cameraNode.position = SCNVector3(x: 0, y: 0, z: 200);
		self.cameraOrbit = SCNNode();
		self.cameraOrbit.addChildNode(self.cameraNode);
		self.scene.rootNode.addChildNode(self.cameraOrbit);
		self.scene.rootNode.castsShadow = true;
	}
	
	override func shouldAutorotate() -> Bool {
		return true;
	}
	
	func addTerrain(){
		self.terrain = Terrain(maxI: self.maxI, maxJ: self.maxJ, size: self.size);
		scene.rootNode.addChildNode(self.terrain.getNode());
	}
	
	func addLights(){
		let ambientLight = SCNLight();
		ambientLight.type = SCNLightTypeAmbient;
		ambientLight.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
		let ambientLightNode = SCNNode()
		ambientLightNode.light = ambientLight;
		ambientLight.castsShadow = true;
		scene.rootNode.addChildNode(ambientLightNode);
		let myDirectLight = SCNLight();
		myDirectLight.type = SCNLightTypeDirectional;
		myDirectLight.color = UIColor.whiteColor();
		self.lightNode = SCNNode();
		self.lightNode.light = myDirectLight;
		self.scene.rootNode.addChildNode(self.lightNode);
	}
	
	func addGestures(){
		self.gestureHandler = GestureHandler(target: self, camera: self.cameraNode, lights:[self.lightNode]);
		self.sceneView.delegate = self.gestureHandler;
	}
	
	func edit(){
		self.terrain!.edit();
	}
	
	func addBase(){
		let baseGeom:SCNGeometry = GeomUtils.getBase(Float(self.maxI) * self.size, numPerSide: 8);
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.orangeColor();
		blueMaterial.locksAmbientWithDiffuse   = true;
		baseGeom.materials = [blueMaterial];
		self.base = SCNNode(geometry: baseGeom);
		self.scene.rootNode.addChildNode(self.base);
	}

	override func viewDidLoad() {
		super.viewDidLoad();
		self.addScene();
		self.addLights();
		self.addCamera();
		self.addGestures();
		self.addBase();
		self.addTerrain();
		self.sceneView.playing = true;
		NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector:(#selector(ViewController.edit)) , userInfo: nil, repeats: true);
		
	}
}
