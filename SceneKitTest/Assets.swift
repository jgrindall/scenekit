//
//  Assets.swift
//  SceneKitTest
//
//  Created by John on 25/06/2016.
//
//

import Foundation
import UIKit
import SceneKit

class Assets{
	
	static var _modifier:String = Assets.getModifier();
	static var _modifier2:String = Assets.getModifier2();
	static var _rock:SCNMaterialProperty = Assets.getRock();
	static var _rock2:SCNMaterialProperty = Assets.getRock2();
	static var _blue:SCNMaterialProperty = Assets.getBlue();
	
	static func getModifier() -> String{
		let wavePath:String = NSBundle.mainBundle().pathForResource("wave", ofType: "shader")!;
		return try! String(contentsOfFile: wavePath);
	}
	
	static func getModifier2() -> String{
		let wavePath:String = NSBundle.mainBundle().pathForResource("wave2", ofType: "shader")!;
		return try! String(contentsOfFile: wavePath);
	}
	
	static func getRock() -> SCNMaterialProperty{
		let imgPath = NSBundle.mainBundle().pathForResource("rock", ofType: "jpg");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getRock2() -> SCNMaterialProperty{
		let imgPath = NSBundle.mainBundle().pathForResource("rock2", ofType: "jpg");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getBlue() -> SCNMaterialProperty{
		let imgPath = NSBundle.mainBundle().pathForResource("blue", ofType: "jpg");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
}

