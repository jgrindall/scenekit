
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
	
	var maxI:CInt = 10;
	var maxJ:CInt = 10;
	var size:Float = 8.0;
	
	func addScene(){
		self.sceneView = SCNView(frame: self.view.frame);
		self.view.addSubview(self.sceneView);
		self.sceneView.autoenablesDefaultLighting = true
		self.sceneView.showsStatistics = true;
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
	
	func addTerrain(){
		self.terrain = Terrain(maxI: self.maxI, maxJ: self.maxJ, size: self.size);
		self.terrain.getNode().opacity = 0.5;
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
		blueMaterial.doubleSided = true;
		baseGeom.materials = [blueMaterial];
		self.base = SCNNode(geometry: baseGeom);
		self.scene.rootNode.addChildNode(self.base);
	}
	
	func addCube(){
		let baseGeom:SCNGeometry = GeomUtils.makeGeometryWithPointsAndTriangles(
			[
				SCNVector3(0, 0, 0),
				SCNVector3(100, 0, 0),
				SCNVector3(100, 100, 0),
				SCNVector3(0, 100, 0),
				
				SCNVector3(0, 0, 100),
				SCNVector3(100, 0, 100),
				SCNVector3(100, 100, 100),
				SCNVector3(0, 100, 100)
			],
			tris: [
				Tri(a: 0, b: 1, c: 2),
				Tri(a: 0, b: 2, c: 3),
				Tri(a: 1, b: 6, c: 2),
				Tri(a: 1, b: 5, c: 6),
				Tri(a: 5, b: 7, c: 6),
				Tri(a: 7, b: 5, c: 4),
				Tri(a: 4, b: 3, c: 7),
				Tri(a: 3, b: 4, c: 0)
			]
		);
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.orangeColor();
		blueMaterial.locksAmbientWithDiffuse   = true;
		//blueMaterial.doubleSided = true;
		baseGeom.materials = [blueMaterial];
		self.base = SCNNode(geometry: baseGeom);
		self.scene.rootNode.addChildNode(self.base);
	}
	
	func addRandom(){
		let baseGeom:SCNGeometry = GeomUtils.makeGeometryWithPointsAndTriangles(
			[
				SCNVector3(0, 0, 0),
				SCNVector3(100, 0, 0),
				SCNVector3(0, 0, 100),
			],
			tris: [
				Tri(a: 0, b: 1, c: 2)
			]
		);
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.orangeColor();
		blueMaterial.locksAmbientWithDiffuse   = true;
		//blueMaterial.doubleSided = true;
		baseGeom.materials = [blueMaterial];
		self.base = SCNNode(geometry: baseGeom);
		self.scene.rootNode.addChildNode(self.base);
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
		self.addScene();
		self.addLights();
		//self.addTerrain();
		self.addBase();
		//self.addRandom();
		self.addCamera();
		self.addGestures();
		self.sceneView.playing = true;
		//NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector:(#selector(ViewController.edit)) , userInfo: nil, repeats: true);
	}
}



