
import UIKit
import SceneKit
import QuartzCore

class ViewController: UIViewController, SCNSceneRendererDelegate {
	
	var sceneView:SCNView!;
	var scene:SCNScene!;
	var cameraNode:SCNNode!;
	var cameraOrbit:SCNNode!;
	var newNode:SCNNode!;
	var lightNode:SCNNode!;
	var originNode:SCNNode!;
	var time0:Float = 0.0;
	var heightMap:HeightMap!;
	var geom:SCNGeometry!;
	
	var maxI:CInt = 30;
	var maxJ:CInt = 50;
	var size:Float = 1.0;
	var height:Float = 1.0;
	
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
	
	func addGeom(){
		self.geom = GeomUtils.makeTopology(self.maxI, maxJ: self.maxJ, size:self.size, height:self.height);
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.blueColor();
		blueMaterial.doubleSided = true;
		self.geom.materials = [blueMaterial];
		self.newNode = SCNNode(geometry: self.geom);
		self.newNode.position = SCNVector3Make(-Float(self.maxJ)*self.size/2.0, 2.0, -Float(self.maxI)*self.size/2.0);
		scene.rootNode.addChildNode(newNode);
		self.geom.shaderModifiers = [
			SCNShaderModifierEntryPointGeometry: Assets.getGeomModifier(),
			SCNShaderModifierEntryPointSurface: Assets.getSurfModifier()
		];
		self.geom.setValue(Assets.getRock2(), forKey: "tex2");
		self.geom.setValue(self.heightMap.get(), forKey: "tex");
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
		self.lightNode.position = SCNVector3Make(2.0, 5.5, 1.5);
		self.scene.rootNode.addChildNode(self.lightNode);
	}
	
	func addGestures(){
		let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(ViewController.handlePanGesture(_:))))
		self.view.addGestureRecognizer(panGesture);
	}
	
	func addHeights(){
		self.heightMap = HeightMap(maxI: self.maxI, maxJ: self.maxJ);
		let imgView:UIImageView = UIImageView(image: self.heightMap.get());
		imgView.contentMode = UIViewContentMode.ScaleAspectFill;
		imgView.frame = CGRectMake(50, 100, 25, 15);
		self.view.addSubview(imgView);
		NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector:(#selector(ViewController.edit)) , userInfo: nil, repeats: true);
	}
	
	func edit(){
		print("edit");
		self.heightMap.setHeightAt(0, j: 0, h: 1);
		self.geom.setValue(self.heightMap.get(), forKey: "tex");
		let imgView:UIImageView = UIImageView(image: self.heightMap.get());
		imgView.contentMode = UIViewContentMode.ScaleAspectFill;
		imgView.frame = CGRectMake(250, 100, 25, 15);
		self.view.addSubview(imgView);
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
		self.addScene();
		self.addLights();
		self.addPlane();
		self.addHeights();
		self.addGeom();
		self.addCamera();
		self.addGestures();
		self.sceneView.playing = true;
	}
}



