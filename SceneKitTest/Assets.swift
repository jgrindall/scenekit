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
	
	static func getGeomModifier() -> String{
		let wavePath:String = NSBundle.mainBundle().pathForResource("geom", ofType: "shader")!;
		return try! String(contentsOfFile: wavePath);
	}
	
	static func getModifier2() -> String{
		let wavePath:String = NSBundle.mainBundle().pathForResource("wave2", ofType: "shader")!;
		return try! String(contentsOfFile: wavePath);
	}
	
	static func getBlue() -> SCNMaterialProperty{
		let imgPath = NSBundle.mainBundle().pathForResource("blue", ofType: "jpg");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getValueForImage(img: UIImage) -> SCNMaterialProperty{
		return SCNMaterialProperty(contents: img);
	}
}

