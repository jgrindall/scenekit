import UIKit
import SceneKit
import QuartzCore

class ViewControllerDemo: UIViewController, SCNSceneRendererDelegate {
	
	var sceneView:SCNView!;
	var scene:SCNScene!;
	var cameraNode:SCNNode!;
	var lightNode:SCNNode!;
	
	func addScene(){
		self.sceneView = SCNView(frame: self.view.frame);
		self.view.addSubview(self.sceneView);
		self.sceneView.showsStatistics = true;
		self.sceneView.allowsCameraControl = true;
		self.sceneView.autoenablesDefaultLighting = false;
		self.sceneView.delegate = self;
		self.scene = SCNScene();
		self.sceneView.scene = scene;
	}
	
	override func shouldAutorotate() -> Bool {
		return true;
	}
	
	func addCamera(){
		self.cameraNode = SCNNode();
		self.cameraNode.camera = SCNCamera();
		self.cameraNode.camera!.xFov = 60;
		self.cameraNode.camera!.yFov  = 60;
		self.cameraNode.camera!.zFar = 1000;
		self.cameraNode.camera!.zNear = 0.01;
		self.cameraNode.position = SCNVector3(x: 0, y: 0, z: 200);
		self.scene.rootNode.addChildNode(self.cameraNode);
		self.scene.rootNode.castsShadow = true;
	}
	
	func addLights(){
		let light0 = SCNLight();
		light0.type = SCNLightTypeOmni;
		light0.color = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1);
		let node0 = SCNNode();
		node0.light = light0;
		node0.position = SCNVector3(300.0, 0.0, 0.0);
		self.scene.rootNode.addChildNode(node0);
		
		let light2 = SCNLight();
		light2.type = SCNLightTypeOmni;
		light2.color = UIColor(red: 0.9, green: 0.6, blue: 1.0, alpha: 1);
		let node2 = SCNNode();
		node2.light = light2;
		node2.position = SCNVector3(0.0, -170.0, -270.0);
		self.scene.rootNode.addChildNode(node2);
		
		let light1 = SCNLight();
		light1.type = SCNLightTypeAmbient;
		light1.color = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1);
		let node1 = SCNNode();
		node1.light = light1;
		self.scene.rootNode.addChildNode(node1);
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
		self.addScene();
		self.addLights();
		self.addCamera();
		let mat = SCNMaterial();
		mat.diffuse.contents = UIColor(red: 0.7, green: 0.2, blue: 0.7, alpha: 1);
		mat.specular.contents = UIColor.whiteColor();
		mat.shininess = 1.0;
		let g = SCNBox(width: 50.0, height: 50.0, length: 50.0, chamferRadius: 0.0);
		let cubeNode = SCNNode(geometry: g);
		self.scene.rootNode.addChildNode(cubeNode);
		g.materials = [mat, mat, mat, mat, mat, mat];
		let spin = CABasicAnimation(keyPath: "rotation");
		spin.byValue = NSValue(SCNVector4: SCNVector4(x: 0.3, y: -0.1, z: 1, w: 2*Float(M_PI)));
		spin.duration = 2;
		spin.repeatCount = HUGE;
		cubeNode.addAnimation(spin, forKey: "spin around");
	}
}
