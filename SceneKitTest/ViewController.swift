
import UIKit
import SceneKit
import QuartzCore



class ViewController: UIViewController, SCNSceneRendererDelegate {
	
	var maxI:CInt =		1;
	var maxJ:CInt =		1;
	var size:Float =	1.5;
	
	var sceneView:		SCNView!;
	var scene:			SCNScene!;
	var cameraNode:		SCNNode!;
	var base:			SCNNode!;
	var terrain:		Terrain!;
	var cameraOrbit:	SCNNode!;
	var lightNode:		SCNNode!;
	var originNode:		SCNNode!;
	var box:			SCNGeometry!;
	var boxNode:		SCNNode!;
	var gestureHandler:	GestureHandler!;
	
	func addScene(){
		self.sceneView = SCNView(frame: self.view.frame);
		self.view.addSubview(self.sceneView);
		self.sceneView.showsStatistics = true;
		self.sceneView.allowsCameraControl = false;
		self.sceneView.autoenablesDefaultLighting = false;
		self.sceneView.delegate = self;
		self.scene = SCNScene();
		self.scene.fogColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.75);
		self.scene.fogStartDistance = 150;
		self.scene.fogEndDistance = 300;
		self.scene?.fogDensityExponent = 1.0;
		//var sky = Assets.getSkyImage();
		//scene.background.contents = [sky, sky, sky, sky, sky, sky];
		self.sceneView.scene = scene;
	}
	
	func addCamera(){
		self.cameraNode = SCNNode();
		self.cameraNode.camera = SCNCamera();
		self.cameraNode.camera!.xFov = 53;
		self.cameraNode.camera!.yFov  = 53;
		self.cameraNode.camera!.zFar = 2000;
		self.cameraNode.camera!.zNear = 0.01;
		self.cameraNode.position = SCNVector3(x: 0, y: 0, z: 200);
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
	
	func addTerrain(){
		self.terrain = Terrain(maxI: self.maxI, maxJ: self.maxJ, size: self.size);
		scene.rootNode.addChildNode(self.terrain.getNode());
	}
	
	func addLights(){
		/*
		let ambientLight = SCNLight();
		ambientLight.type = SCNLightTypeAmbient;
		ambientLight.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
		let ambientLightNode = SCNNode()
		ambientLightNode.light = ambientLight;
		ambientLight.castsShadow = true;
		ambientLightNode.castsShadow = true;
		scene.rootNode.addChildNode(ambientLightNode);
		let myDirectLight = SCNLight();
		myDirectLight.type = SCNLightTypeDirectional;
		myDirectLight.color = UIColor.whiteColor();
		myDirectLight.castsShadow = true;
		self.lightNode = SCNNode();
		self.lightNode.light = myDirectLight;
		self.scene.rootNode.addChildNode(self.lightNode);
		self.lightNode.castsShadow = true;
		myDirectLight.shadowMode = SCNShadowMode.Forward;
		
		let omniLight = SCNLight()
		omniLight.type = SCNLightTypeOmni
		let omniLightNode = SCNNode()
		omniLightNode.light = omniLight
		omniLightNode.position = SCNVector3(1.5, 1.5, 1.5)
		
		// set up a Spot light
*/
		let cNode = SCNNode();
		cNode.transform = SCNMatrix4MakeRotation(Float(M_PI), 0, 0, 1);
		cNode.position = SCNVector3(Float(self.maxI)*self.size/2, 50, Float(self.maxI)*self.size/2)
		
		let spotLight = SCNLight();
		spotLight.color = UIColor.whiteColor();
		spotLight.type = SCNLightTypeSpot;
		spotLight.spotInnerAngle = 20.0;
		spotLight.spotOuterAngle = 120.0;
		spotLight.castsShadow = true;
		
		let spotLightNode = SCNNode();
		spotLightNode.castsShadow = true;
		spotLightNode.light = spotLight;
		
		let sphereGeom = SCNSphere(radius: 2);
		let sphereGeom2 = SCNSphere(radius: 0.5);
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.redColor();
		sphereGeom.materials = [blueMaterial];
		sphereGeom2.materials = [blueMaterial];
		
		let sphereNode = SCNNode(geometry: sphereGeom);
		let sphereNode2 = SCNNode(geometry: sphereGeom2);
		sphereNode2.position = SCNVector3Make(5.0, 0.0, 0.0);
		
		cNode.addChildNode(sphereNode);
		cNode.addChildNode(sphereNode2);
		cNode.addChildNode(spotLightNode);
		self.scene.rootNode.addChildNode(cNode);
		
		NSTimer.scheduledTimerWithTimeInterval(1,
			target: NSBlockOperation(
				block: {
					let a:Float = 6 * Float(arc4random() % 1000000) / 1000000.0;
					let x:Float = Float(arc4random() % 1000000) / 1000000.0
					let y:Float = Float(arc4random() % 1000000) / 1000000.0
					let z:Float = Float(arc4random() % 1000000) / 1000000.0
					print(a, x, y, z);
					cNode.position = SCNVector3Zero;
					cNode.transform = SCNMatrix4MakeRotation(a, x, y, z);
					cNode.position = SCNVector3(Float(self.maxI)*self.size/2, 50, Float(self.maxI)*self.size/2)
				}
			),
			selector: #selector(NSOperation.main),
			userInfo: nil,
			repeats: true
		);
	}
	
	func addGestures(){
		self.gestureHandler = GestureHandler(target: self, camera: self.cameraNode, lights:[]);
		self.sceneView.delegate = self.gestureHandler;
	}
	
	func edit(){
		self.terrain!.edit();
		//self.updateHeight();
	}
	
	func addBase(){
		let baseGeom:SCNGeometry = Base.getBase(Float(self.maxI) * self.size, numPerSide: 12);
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = Assets.getSoilImage();
		baseGeom.firstMaterial = blueMaterial;
		self.base = SCNNode(geometry: baseGeom);
		self.scene.rootNode.addChildNode(self.base);
		self.base.opacity = 0.25;
	}

	override func viewDidLoad(){
		super.viewDidLoad()
		
		// set the view to match the current view size
		let sceneView = SCNView(frame: self.view.frame)
		self.view.addSubview(sceneView)
		
		// set up a scene
		self.scene = SCNScene()
		sceneView.scene = self.scene
		sceneView.allowsCameraControl = true;
		sceneView.autoenablesDefaultLighting = false;
		// create some geometry
		let cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
		let cubeGeometry2 = SCNBox(width: 0.7, height: 0.7, length: 0.7, chamferRadius: 0.0)
		let cubeNode = SCNNode(geometry: cubeGeometry)
		let cubeNode2 = SCNNode(geometry: cubeGeometry2)
		cubeNode2.position = SCNVector3(1.2, 2, 1.2);
		
		let planeGeometry = SCNPlane(width: 15.0, height: 15.0)
		let planeNode = SCNNode(geometry: planeGeometry)
		planeNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
		planeNode.position = SCNVector3(x: 0.0, y: -0.5, z: 0.0)
		
		// materials
		let cubeMaterial = SCNMaterial()
		

		cubeMaterial.diffuse.contents = Assets.getSoilImage();
		cubeGeometry.materials = [cubeMaterial];
		cubeGeometry.shaderModifiers = [
			SCNShaderModifierEntryPointGeometry: Assets.getGeomModifier2()
		];
		cubeGeometry2.materials = [cubeMaterial];
		cubeGeometry2.shaderModifiers = [
			SCNShaderModifierEntryPointGeometry: Assets.getGeomModifier3()
		];
		//cubeGeometry2.shaderModifiers = [
			//SCNShaderModifierEntryPointGeometry: Assets.getGeomModifier2()
		//];
		let planeMaterial = SCNMaterial()
		planeMaterial.diffuse.contents = UIColor.blueColor()
		planeGeometry.materials = [planeMaterial]
		
		// set up a Perspective camera
		let camera = SCNCamera()
		let cameraNode = SCNNode()
		cameraNode.camera = camera
		cameraNode.position = SCNVector3(-5.0, 5.0, 5.0)
		
		// set up optional lookAt constraint for the camera
		let constraint = SCNLookAtConstraint(target: cubeNode)
		constraint.gimbalLockEnabled = true
		cameraNode.constraints = [constraint]

		
		// set up a Spot light
		let spotLight = SCNLight()
		spotLight.type = SCNLightTypeSpot
		spotLight.spotInnerAngle = 30.0
		spotLight.spotOuterAngle = 80.0
		spotLight.castsShadow = true
		let spotLightNode = SCNNode()
		spotLightNode.light = spotLight
		spotLightNode.position = SCNVector3(1.5, 3.5, 1.5)
		spotLightNode.constraints = [constraint]
		
		let sphereGeom = SCNSphere(radius: 0.1);
		let blackMaterial = SCNMaterial();
		blackMaterial.diffuse.contents = UIColor.blackColor();
		sphereGeom.firstMaterial = blackMaterial;
		let sphereNode = SCNNode(geometry: sphereGeom);
		self.scene.rootNode.addChildNode(sphereNode);
		sphereNode.position = spotLightNode.position;
		
		
		
		
		// set up an ambient light
		let ambientLight = SCNLight()
		ambientLight.type = SCNLightTypeAmbient
		ambientLight.color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.05)
		cameraNode.light = ambientLight
		
		// add nodes to the scene (make them viewable)
		self.scene.rootNode.addChildNode(spotLightNode)
		self.scene.rootNode.addChildNode(cameraNode)
		self.scene.rootNode.addChildNode(cubeNode)
		self.scene.rootNode.addChildNode(cubeNode2)
		self.scene.rootNode.addChildNode(planeNode)
		sceneView.playing = true;
		self.addTerrain();
		//NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector:(#selector(ViewController.edit)) , userInfo: nil, repeats: true);
	}
	
	/*override func viewDidLoad2() {
		super.viewDidLoad();
		self.addScene();
		self.addLights();
		self.addCamera();
		self.addGestures();
		self.addBase();
		self.addTerrain();
		self.sceneView.playing = true;
		NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector:(#selector(ViewController.edit)) , userInfo: nil, repeats: true);
		
	}*/
}
