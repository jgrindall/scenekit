
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
	var time0:Float = 0.0;
	var terrain:Terrain!;
	
	var maxI:CInt = 20;
	var maxJ:CInt = 20;
	var size:Float = 6.0;
	
	var slideVel:CGPoint = CGPointZero;
	
	func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		let old:SCNMatrix4 = self.cameraNode.transform;
		let rX:SCNMatrix4 = SCNMatrix4MakeRotation(-Float(self.slideVel.x)/10000.0, 0, 1, 0);
		let rY:SCNMatrix4 = SCNMatrix4MakeRotation(-Float(self.slideVel.y)/10000.0, 1, 0, 0);
		let netRot:SCNMatrix4 = SCNMatrix4Mult(rX, rY);
		self.cameraNode.transform = SCNMatrix4Mult(old, netRot);
		if (self.slideVel.x > -0.1 && self.slideVel.x < 0.1) {
			self.slideVel.x = 0;
		}
		else {
			self.slideVel.x += (self.slideVel.x > 0) ? -1 : 1;
		}
		
		if (self.slideVel.y > -0.1 && self.slideVel.y < 0.1) {
			self.slideVel.y = 0;
		}
		else {
			self.slideVel.y += (self.slideVel.y > 0) ? -1 : 1;
		}
	}
	
	func handlePanGesture(panGesture: UIPanGestureRecognizer){
		self.slideVel = panGesture.velocityInView(self.view);
	};
	
	func addScene(){
		self.sceneView = SCNView(frame: self.view.frame);
		self.sceneView.delegate = self;
		self.view.addSubview(self.sceneView);
		self.sceneView.showsStatistics = true;
		self.scene = SCNScene();
		self.sceneView.scene = scene;
	}
	
	func addCamera(){
		self.cameraNode = SCNNode();
		self.cameraNode.camera = SCNCamera();
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
		let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(ViewController.handlePanGesture(_:))))
		self.view.addGestureRecognizer(panGesture);
	}
	
	func edit(){
		self.terrain.edit();
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
		self.addScene();
		self.addLights();
		self.addPlane();
		self.addTerrain();
		self.addCamera();
		self.addGestures();
		self.sceneView.playing = true;
		NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector:(#selector(ViewController.edit)) , userInfo: nil, repeats: false);
	}
}



