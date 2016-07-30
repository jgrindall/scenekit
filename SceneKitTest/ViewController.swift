
import UIKit
import SceneKit
import QuartzCore

class ViewController: UIViewController, SCNSceneRendererDelegate {
	
	var sceneView:SCNView!;
	var scene:SCNScene!;
	var cameraNode:SCNNode!;
	var cameraOrbit:SCNNode!;
	var lightNode:SCNNode!;
	var originNode:SCNNode!;
	var base:SCNNode!;
	var terrain:Terrain!;
	var gestureHandler:GestureHandler!;
	
	var maxI:CInt = 20;
	var maxJ:CInt = 20;
	var size:Float = 6.0;
	
	func addScene(){
		self.sceneView = SCNView(frame: self.view.frame);
		self.view.addSubview(self.sceneView);
		self.sceneView.showsStatistics = true;
		self.scene = SCNScene();
		self.sceneView.scene = scene;
	}

	func addCamera(){
		self.cameraNode = SCNNode();
		self.cameraNode.camera = SCNCamera();
		//self.cameraNode.camera?.usesOrthographicProjection = true;
		self.cameraNode.position = SCNVector3(x: 0, y: 0, z: 70);
		self.cameraOrbit = SCNNode();
		self.cameraOrbit.addChildNode(self.cameraNode);
		self.scene.rootNode.addChildNode(self.cameraOrbit);
		self.scene.rootNode.castsShadow = true;
	}
	
	func addPlane(){
		let planeGeometry = SCNPlane(width: 100.0, height: 100.0);
		let planeNode = SCNNode(geometry: planeGeometry);
		planeNode.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90.0), 0, 0);
		planeNode.position = SCNVector3Make(0, -0.5, 0);
		let greenMaterial = SCNMaterial();
		greenMaterial.diffuse.contents = UIColor.grayColor();
		planeGeometry.materials = [greenMaterial];
		scene.rootNode.addChildNode(planeNode);
	}
	
	func addTerrain(){
		self.terrain = Terrain(maxI: self.maxI, maxJ: self.maxJ, size: self.size);
		scene.rootNode.addChildNode(self.terrain.getNode());
	}
	
	func addLights(){
		let ambientLight = SCNLight();
		ambientLight.type = SCNLightTypeAmbient;
		ambientLight.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		let ambientLightNode = SCNNode()
		ambientLightNode.light = ambientLight;
		ambientLight.castsShadow = true;
		scene.rootNode.addChildNode(ambientLightNode)
		let light = SCNLight();
		light.type = SCNLightTypeSpot;
		light.spotInnerAngle = 60.0;
		light.spotOuterAngle = 120.0;
		light.castsShadow = true;
		self.lightNode = SCNNode()
		self.lightNode.light = light;
		self.lightNode.position = SCNVector3Make(2.0, 50.5, 1.5);
		self.scene.rootNode.addChildNode(self.lightNode);
	}
	
	func addGestures(){
		self.gestureHandler = GestureHandler(target: self, camera: self.cameraNode);
		self.sceneView.delegate = self.gestureHandler;
	}
	
	func edit(){
		self.terrain.edit();
	}
	
	func addBase(){
		let baseGeom:SCNGeometry = GeomUtils.getBase(120.0, numPerSide: 4);
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.orangeColor();
		baseGeom.materials = [blueMaterial];
		self.base = SCNNode(geometry: baseGeom);
		self.scene.rootNode.addChildNode(self.base);
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
		self.addScene();
		self.addLights();
		self.addPlane();
		self.addTerrain();
		self.addBase();
		self.addCamera();
		self.addGestures();
		self.sceneView.playing = true;
		NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector:(#selector(ViewController.edit)) , userInfo: nil, repeats: true);
	}
}



