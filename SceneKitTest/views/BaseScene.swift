
import UIKit
import SceneKit
import QuartzCore
import JavaScriptCore

public class BaseScene {
	
	private var sceneView:			SCNView!;
	private var scene:				SCNScene!;
	private var cameraNode:			SCNNode!;
	private var cameraOrbit:		SCNNode!;
	private var lightNode:			SCNNode!;
	
	
	init(frame:CGRect) {
		self.addScene(frame:frame);
		self.addLights();
		self.addCamera();
		
		self.sceneView.isPlaying = true;
		self.sceneView.play(self);
	}
	
	func getSceneView() -> SCNView{
		return self.sceneView;
	}
	
	func getRootNode() -> SCNNode{
		return self.scene.rootNode;
	}
	
	func getCameraNode() -> SCNNode{
		return self.cameraNode;
	}
	
	private func addScene(frame:CGRect){
		self.sceneView = SCNView(frame: frame);
		self.sceneView.showsStatistics = true;
		self.sceneView.allowsCameraControl = false;
		self.sceneView.autoenablesDefaultLighting = false;
		self.sceneView.loops = true;
		self.scene = SCNScene();
		self.scene.background.contents = [
			UIImage(named: "bg2.png"),
			UIImage(named: "bg3.png"),
			UIImage(named: "bg2.png"),
			UIImage(named: "bg3.png"),
			UIImage(named: "bg2.png"),
			UIImage(named: "bg3.png")
		];
		self.sceneView.scene = scene;
	}
	
	func play(){
		self.sceneView.isPlaying = true;
		self.sceneView.play(self);
	}
	
	private func addCamera(){
		self.cameraNode = SCNNode();
		self.cameraNode.camera = SCNCamera();
		self.cameraNode.camera!.xFov = 53;
		self.cameraNode.camera!.yFov  = 53;
		self.cameraNode.camera!.zFar = 2000;
		self.cameraNode.camera!.zNear = 0.01;
		self.cameraNode.position = SCNVector3(x: 0, y: 0, z: 1000);
		self.cameraOrbit = SCNNode();
		self.cameraOrbit.addChildNode(self.cameraNode);
		self.getRootNode().addChildNode(self.cameraOrbit);
		self.getRootNode().castsShadow = true;
		self.sceneView.pointOfView = self.cameraNode;
	}
	
	private func addLights(){
		let ambientLight = SCNLight();
		ambientLight.type = SCNLight.LightType.ambient;
		ambientLight.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.75);
		let ambientLightNode = SCNNode();
		ambientLightNode.light = ambientLight;
		ambientLight.castsShadow = true;
		ambientLightNode.castsShadow = true;
		let cNode = SCNNode();
		cNode.transform = SCNMatrix4MakeRotation(Float(M_PI), 0, 0, 1);
		cNode.position = SCNVector3(400, 150, 400);
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
		self.getRootNode().addChildNode(ambientLightNode);
		self.getRootNode().addChildNode(cNode);
	}
}
