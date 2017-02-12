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

open class GestureHandler : NSObject, SCNSceneRendererDelegate, UIGestureRecognizerDelegate{
	
	fileprivate var _slideVel:CGPoint = CGPoint.zero;
	fileprivate var _target:UIViewController!;
	fileprivate var _cameraNode:SCNNode!;
	fileprivate var _lights:Array<SCNNode>!;
	
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
		self._target.view.isUserInteractionEnabled = true;
		let panGesture = UIPanGestureRecognizer(target: self, action:#selector(self.handlePanGesture(_:)));
		panGesture.delegate = self;
		self._target.view.addGestureRecognizer(panGesture);
	}
	
	open func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		let old:SCNMatrix4 = self._cameraNode.transform;
		let dx:Float = Float(self._slideVel.x)/GestureHandler.Consts.VEL_SCALE;
		let dy:Float = Float(self._slideVel.y)/GestureHandler.Consts.VEL_SCALE;
		let INC:CGFloat = 0.97;
		let rX:SCNMatrix4 = SCNMatrix4MakeRotation(-dx, 0, 1, 0);
		let rY:SCNMatrix4 = SCNMatrix4MakeRotation(-dy, 1, 0, 0);
		let netRot:SCNMatrix4 = SCNMatrix4Mult(rX, rY);
		if (fabs(self._slideVel.x) < GestureHandler.Consts.MIN_VEL) {
			self._slideVel.x = 0;
		}
		else {
			self._slideVel.x *= INC;
		}
		
		if (fabs(self._slideVel.y) < GestureHandler.Consts.MIN_VEL) {
			self._slideVel.y = 0;
		}
		else {
			self._slideVel.y *= INC;
		}
		self._cameraNode.transform = SCNMatrix4Mult(old, netRot);
		if(self._lights != nil){
			for n in self._lights{
				n.transform = self._cameraNode.transform;
			}
		}
	}
	
	@objc open func handlePanGesture(_ panGesture: UIPanGestureRecognizer){
		self._slideVel = panGesture.velocity(in: self._target.view);
	}

}

