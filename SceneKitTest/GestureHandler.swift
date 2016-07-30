//
//  CachedImage.swift
//  SceneKitTest
//
//  Created by John on 26/06/2016.
//
//

import Foundation
import SceneKit
import QuartzCore

@objc

public class GestureHandler : NSObject, SCNSceneRendererDelegate, UIGestureRecognizerDelegate{
	
	private var _slideVel:CGPoint = CGPointZero;
	private var _target:UIViewController!;
	private var _cameraNode:SCNNode!;
	private var _lights:Array<SCNNode>!;
	
	struct Consts {
		static let VEL_SCALE:Float = 12000.0;
		static let MIN_VEL:CGFloat = 0.1;
	}
	
	init(target:UIViewController, camera:SCNNode, lights:Array<SCNNode>? = nil){
		super.init();
		self._target = target;
		self._cameraNode = camera;
		self._lights = lights;
		self.add();
	}
	
	func add(){
		self._target.view.userInteractionEnabled = true;
		let panGesture = UIPanGestureRecognizer(target: self, action:#selector(self.handlePanGesture(_:)));
		panGesture.delegate = self;
		self._target.view.addGestureRecognizer(panGesture);
	}
	
	public func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		let old:SCNMatrix4 = self._cameraNode.transform;
		let dx:Float = Float(self._slideVel.x)/GestureHandler.Consts.VEL_SCALE;
		let dy:Float = Float(self._slideVel.y)/GestureHandler.Consts.VEL_SCALE;
		let INC:CGFloat = 1;
		let rX:SCNMatrix4 = SCNMatrix4MakeRotation(-dx, 0, 1, 0);
		let rY:SCNMatrix4 = SCNMatrix4MakeRotation(-dy, 1, 0, 0);
		let netRot:SCNMatrix4 = SCNMatrix4Mult(rX, rY);
		if (fabs(self._slideVel.x) < GestureHandler.Consts.MIN_VEL) {
			self._slideVel.x = 0;
		}
		else {
			self._slideVel.x += (self._slideVel.x > 0) ? -INC : INC;
		}
		
		if (fabs(self._slideVel.y) < GestureHandler.Consts.MIN_VEL) {
			self._slideVel.y = 0;
		}
		else {
			self._slideVel.y += (self._slideVel.y > 0) ? -INC : INC;
		}
		self._cameraNode.transform = SCNMatrix4Mult(old, netRot);
		if(self._lights != nil){
			for n in self._lights{
				n.transform = self._cameraNode.transform;
			}
		}
	}
	
	@objc public func handlePanGesture(panGesture: UIPanGestureRecognizer){
		self._slideVel = panGesture.velocityInView(self._target.view);
	}

}

