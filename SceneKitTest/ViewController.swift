
import UIKit
import SceneKit
import QuartzCore

class ViewController: UIViewController {
	
	var sceneView:SCNView!;
	var scene:SCNScene!;
	var cameraNode:SCNNode!;
	var cubeNode:SCNNode!;
	var lightNode:SCNNode!;
	
	func addScene(){
		self.sceneView = SCNView(frame: self.view.frame);
		self.view.addSubview(self.sceneView)
		self.sceneView.showsStatistics = true
		self.scene = SCNScene()
		self.sceneView.scene = scene;
		
		let camera = SCNCamera()
		self.cameraNode = SCNNode()
		self.cameraNode.camera = camera;
		self.cameraNode.position = SCNVector3Make(-3.0, 3.0, 3.0);
		self.scene.rootNode.addChildNode(self.cameraNode);
	}
	
	func addGeom(){
		let cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.05)
		self.cubeNode = SCNNode(geometry: cubeGeometry)
		
		let planeGeometry = SCNPlane(width: 100.0, height: 100.0);
		let planeNode = SCNNode(geometry: planeGeometry)
		planeNode.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90.0), 0, 0);
		planeNode.position = SCNVector3Make(0, -0.5, 0);
		
		let redMaterial = SCNMaterial();
		redMaterial.diffuse.contents = UIColor.redColor();
		cubeGeometry.materials = [redMaterial];
		
		let greenMaterial = SCNMaterial();
		greenMaterial.diffuse.contents = UIColor.greenColor();
		planeGeometry.materials = [greenMaterial];
		
		scene.rootNode.addChildNode(self.cubeNode);
		scene.rootNode.addChildNode(planeNode);
		
		let path = NSBundle.mainBundle().pathForResource("wave", ofType: "shader");
		
		let path2 = NSBundle.mainBundle().pathForResource("wave2", ofType: "shader");
		
		let imgPath = NSBundle.mainBundle().pathForResource("rock", ofType: "jpg");
		let img = UIImage(contentsOfFile: imgPath!);
		
		let imgPath2 = NSBundle.mainBundle().pathForResource("green2", ofType: "png");
		let img2 = UIImage(contentsOfFile: imgPath2!);
		
		
		let mProp = SCNMaterialProperty(contents: img!);
		let mProp2 = SCNMaterialProperty(contents: img2!);
		let modifier = try? String(contentsOfFile: path!)
		let modifier2 = try? String(contentsOfFile: path2!)
		cubeGeometry.shaderModifiers = [
			SCNShaderModifierEntryPointSurface: modifier2!,
			SCNShaderModifierEntryPointGeometry: modifier!
		];
		SCNTransaction.begin()
		SCNTransaction.setAnimationDuration(30)
		cubeGeometry.setValue(mProp, forKey: "tex")
		cubeGeometry.setValue(mProp2, forKey: "tex2")
		SCNTransaction.commit()
	}
	
	func addLights(){
		let ambientLight = SCNLight();
		ambientLight.type = SCNLightTypeAmbient;
		ambientLight.color = UIColor(red: 0.8, green: 0.8, blue: 0.9, alpha: 1.0)
		
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
		let constraint = SCNLookAtConstraint(target: self.cubeNode)
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



