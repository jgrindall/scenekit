
import UIKit
import SceneKit
import QuartzCore



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
	var cachedTree:			SCNNode!;
	var trees:				Array<SCNNode>!;
	
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
		self.sceneView.scene = scene;
		self.trees = [SCNNode]();
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
		for tree in self.trees {
			tree.position.setX(tree.position.x + r0);
			tree.position.setZ(tree.position.z + r1);
		}
	}
	
	func collada2SCNNode(_ filepath:String) -> SCNNode {
		let node = SCNNode()
		let scene = SCNScene(named: filepath)
		let nodeArray = scene!.rootNode.childNodes
		
		for childNode in nodeArray {
			node.addChildNode(childNode as SCNNode)
		}
		return node
	}
	
	func getTree() -> SCNNode{
		if((self.cachedTree == nil)){
			//self.cachedTree = collada2SCNNode("model.dae");
			let b0 = SCNNode(geometry:SCNBox(width: 8, height: 8, length: 5, chamferRadius: 0));
			let b1 = SCNNode(geometry:SCNBox(width: 3, height: 3, length: 5, chamferRadius: 0));
			b1.position.setX(5);
			self.cachedTree = SCNNode();
			self.cachedTree.addChildNode(b0);
			self.cachedTree.addChildNode(b1);
		}
		return self.cachedTree;
	}
	
	func addCubes(){
		for i in 0...35{
			for j in 0...35{
				let cGeom:SCNPlane = SCNPlane(width: 20.0, height: 20.0);
				cGeom.widthSegmentCount = 1;
				cGeom.heightSegmentCount = 1;
				let redMaterial = SCNMaterial();
				redMaterial.diffuse.contents = UIColor.red;
				cGeom.firstMaterial = redMaterial;
				let cNode = SCNNode(geometry: cGeom);
				cNode.eulerAngles = SCNVector3Make(0, 1.57, 0);
				self.scene.rootNode.addChildNode(cNode);
				cNode.position = SCNVector3Make(Float(i)*20.0, 0.0, Float(j)*20.0);
				
				let tree:SCNNode = self.getTree().clone();
				self.scene.rootNode.addChildNode(tree);
				tree.position = SCNVector3Make(Float(i)*20.0, 0.0, Float(j)*20.0);
				self.trees.append(tree);
				//tree.scale = SCNVector3(0.1,0.1,0.1);
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
		self.addScene();
		self.addLights();
		self.addCamera();
		self.addGestures();
		self.addCubes();
		self.sceneView.isPlaying = true;
		let delayTime = DispatchTime.now() + Double(Int64(10 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: delayTime) {
			Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:(#selector(ViewController.edit)), userInfo: nil, repeats: true);
		}
	}
}
