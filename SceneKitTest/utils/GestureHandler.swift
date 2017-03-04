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
	fileprivate var _delegate:PGestureDelegate!;
	fileprivate var _still:Bool = true;
	fileprivate var _transform:SCNMatrix4!;
	
	struct Consts {
		static let VEL_SCALE:Float = 12000.0;
		static let MIN_VEL:CGFloat = 0.1;
		static let INCREMENT_FACTOR:CGFloat = 0.5;
	}
	
	init(target:UIViewController, delegate:PGestureDelegate){
		super.init();
		self._target = target;
		self._delegate = delegate;
		self.add();
	}
	
	func add(){
		print("add", self._target, self._target.view);
		self._target.view.isUserInteractionEnabled = true;
		let panGesture = UIPanGestureRecognizer(target: self, action:#selector(self.handlePanGesture(_:)));
		panGesture.delegate = self;
		panGesture.cancelsTouchesInView = false;
		self._target.view.addGestureRecognizer(panGesture);
	}
	
	func onTransform(t:SCNMatrix4){
		self._delegate.onTransform(t:t);
	}
	
	func _guard(){
		if (fabs(self._slideVel.x) < GestureHandler.Consts.MIN_VEL) {
			self._slideVel.x = 0;
		}
		else {
			self._slideVel.x *= GestureHandler.Consts.INCREMENT_FACTOR;
		}
		
		if (fabs(self._slideVel.y) < GestureHandler.Consts.MIN_VEL) {
			self._slideVel.y = 0;
		}
		else {
			self._slideVel.y *= GestureHandler.Consts.INCREMENT_FACTOR;
		}
	}
	
	func checkVelocity(){
		if(self._slideVel.x == 0 && self._slideVel.y == 0){
			if(self._still == false){
				self._still = true;
				self._delegate.onFinished();
			}
		}
		else{
			if(self._still == true){
				self._still = false;
				self._delegate.onStart();
			}
		}
	}
	
	func onRender(){
		let dx:Float = Float(self._slideVel.x)/GestureHandler.Consts.VEL_SCALE;
		let dy:Float = Float(self._slideVel.y)/GestureHandler.Consts.VEL_SCALE;
		let rX:SCNMatrix4 = SCNMatrix4MakeRotation(-dx, 0, 1, 0);
		let rY:SCNMatrix4 = SCNMatrix4MakeRotation(-dy, 1, 0, 0);
		let netRot:SCNMatrix4 = SCNMatrix4Mult(rX, rY);
		self._delegate.onTransform(t: netRot);
		self._guard();
		self.checkVelocity();
	}
	
	@objc open func handlePanGesture(_ panGesture: UIPanGestureRecognizer){
		self._slideVel = panGesture.velocity(in: self._target.view);
	}

}

