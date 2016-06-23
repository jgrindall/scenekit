
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
	
	struct Tri {
		var a: Int;
		var b: Int;
		var c: Int;
	}
	
	struct Sqr {
		var a: Int;
		var b: Int;
		var c: Int;
		var d: Int;
	}
	
	func makeTopology(m:Int, n:Int) -> SCNGeometry{
		var size:Float = 0.5;
		var a:Array<SCNVector3> = [SCNVector3]();
		for i in 0...n{
			for j in 0...m{
				a.append(SCNVector3Make(Float(j)*size, Float(i)*size, 0));
			}
		}
		for i in 0...n{
			for j in 0...m{
				a.append(SCNVector3Make(Float(j)*size, Float(i)*size, 1));
			}
		}
		var sqrs:Array<Sqr> = [Sqr]();
		//add sqr
		func getIndexA(i:Int, j:Int) -> Int{
			return i*m + j;
		}
		func getIndexB(i:Int, j:Int) -> Int{
			return getIndexA(i, j: j) + (m * n);
		}
		var sqr:Sqr;
		for i in 0...n - 1{
			for j in 0...m - 1{
				sqr = Sqr(a: getIndexA(i, j: j), b: getIndexA(i + 1, j: j), c: getIndexA(i + 1, j: j + 1), d: getIndexA(i, j: j + 1));
				sqrs.append(sqr);
				sqr = Sqr(a: getIndexB(i, j: j), b: getIndexB(i + 1, j: j), c: getIndexB(i + 1, j: j + 1), d: getIndexB(i, j: j + 1));
				sqrs.append(sqr);
			}
		}
		return makeGeometryWithPointsAndSquares(a, sqrs: sqrs);
	}
	
	func makeGeometryWithPointsAndSquares(positions:Array<SCNVector3>, sqrs:Array<Sqr>) -> SCNGeometry{
		var tris = [Tri]();
		for s:Sqr in sqrs{
			tris.append(Tri(a: s.a, b: s.b, c: s.c));
			tris.append(Tri(a: s.c, b: s.d, c: s.a));
		}
		return makeGeometryWithPointsAndTriangles(positions, tris: tris);
	}
	
	func makeGeometryWithPointsAndTriangles(positions:Array<SCNVector3>, tris:Array<Tri>) -> SCNGeometry{
		var indices:Array<Int> = [Int]();
		for v:Tri in tris{
			indices.append(v.a);
			indices.append(v.b);
			indices.append(v.c);
		}
		let vertexSource = SCNGeometrySource(vertices: positions, count:positions.count);
		let indexData = NSData(bytes: indices, length: indices.count * sizeof(Int));
		let element = SCNGeometryElement(data: indexData, primitiveType: SCNGeometryPrimitiveType.Triangles, primitiveCount: indices.count, bytesPerIndex: sizeof(Int));
		return SCNGeometry(sources: [vertexSource], elements: [element]);
	}
	
	func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		self.posCamera(time);
	}
	
	func posCamera(t:Double){
		var r:Float = 10.0;
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
		/*
		let cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.05)
		cubeGeometry.widthSegmentCount = 1;
		cubeGeometry.heightSegmentCount = 1;
		cubeGeometry.lengthSegmentCount = 1;
		self.cubeNode = SCNNode(geometry: cubeGeometry)
		
		let s:Float = 0.5;
		let positions = [
			SCNVector3Make(-s, -s,  s),
			SCNVector3Make( s, -s,  s),
			SCNVector3Make(-s, -s, -s),
			SCNVector3Make( s, -s, -s),
			SCNVector3Make(-s,  s,  s),
			SCNVector3Make( s,  s,  s),
			SCNVector3Make(-s,  s, -s),
			SCNVector3Make( s,  s, -s)
		];
		
		let tris = [
			Tri(a: 0, b: 2, c: 1),
			Tri(a: 1, b: 2, c: 3),
			Tri(a: 2, b: 6, c: 3),
			Tri(a: 3, b: 6, c: 7),
			Tri(a: 0, b: 4, c: 2),
			Tri(a: 2, b: 4, c: 6),
			Tri(a: 1, b: 3, c: 5),
			Tri(a: 3, b: 7, c: 5),
			Tri(a: 0, b: 1, c: 4),
			Tri(a: 1, b: 5, c: 4),
			Tri(a: 4, b: 5, c: 6),
			Tri(a: 5, b: 7, c: 6)
		];
		*/
		
		//let gameGeometry = makeGeometryWithPointsAndTriangles(positions, tris: tris);
		
		let newGeometry:SCNGeometry = makeTopology(5, n: 4);
		
		let planeGeometry = SCNPlane(width: 100.0, height: 100.0);
		let planeNode = SCNNode(geometry: planeGeometry)
		planeNode.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90.0), 0, 0);
		planeNode.position = SCNVector3Make(0, -0.5, 0);
		
		let redMaterial = SCNMaterial();
		redMaterial.diffuse.contents = UIColor.redColor();
		//cubeGeometry.materials = [redMaterial];
		
		let greenMaterial = SCNMaterial();
		greenMaterial.diffuse.contents = UIColor.grayColor();
		//planeGeometry.materials = [greenMaterial];
		
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.blueColor();
		//gameGeometry.materials = [blueMaterial];
		
		newGeometry.materials = [blueMaterial, greenMaterial, redMaterial];
		
		//let gameNode = SCNNode(geometry: gameGeometry);
		//gameNode.position = SCNVector3Make(1.0, 0.7, 0.6);
		
		self.newNode = SCNNode(geometry: newGeometry);
		self.newNode.position = SCNVector3Make(-1.0, 1.3, -0.6);
		
		//scene.rootNode.addChildNode(self.cubeNode);
		scene.rootNode.addChildNode(planeNode);
		//scene.rootNode.addChildNode(gameNode);
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
		/*
		cubeGeometry.shaderModifiers = [
			SCNShaderModifierEntryPointSurface: modifier2!,
			SCNShaderModifierEntryPointGeometry: modifier!
		];
		cubeGeometry.setValue(mProp, forKey: "tex")
		cubeGeometry.setValue(mProp2, forKey: "tex2")
		*/
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



