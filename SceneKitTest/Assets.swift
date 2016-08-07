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
	
	static func getShared() -> String{
		let path:String = NSBundle.mainBundle().pathForResource("shared", ofType: "txt")!;
		return try! String(contentsOfFile: path);
	}
	
	static func getGeomModifier() -> String{
		let path:String = NSBundle.mainBundle().pathForResource("geom", ofType: "shader")!;
		let s:String = try! String(contentsOfFile: path);
		let newS = s.stringByReplacingOccurrencesOfString("%shared%", withString: Assets.getShared());
		return newS;
	}
	
	static func getSurfModifier() -> String{
		let path:String = NSBundle.mainBundle().pathForResource("surf", ofType: "shader")!;
		let s:String = try! String(contentsOfFile: path);
		let newS = s.stringByReplacingOccurrencesOfString("%shared%", withString: Assets.getShared());
		return newS;
	}
	
	static func getSoil() -> SCNMaterialProperty{
		let imgPath = NSBundle.mainBundle().pathForResource("stones1", ofType: "png");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getStone() -> SCNMaterialProperty{
		let imgPath = NSBundle.mainBundle().pathForResource("stone", ofType: "png");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getGrass() -> SCNMaterialProperty{
		let imgPath = NSBundle.mainBundle().pathForResource("grass", ofType: "png");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getValueForImage(img: UIImage) -> SCNMaterialProperty{
		return SCNMaterialProperty(contents: img);
	}
	
	static func getRock2() -> SCNMaterialProperty{
		let imgPath = NSBundle.mainBundle().pathForResource("rock2", ofType: "jpg");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getWhite() -> SCNMaterialProperty{
		return SCNMaterialProperty(contents: Assets.getWhiteImg());
	}
	
	static func getGrey() -> SCNMaterialProperty{
		return SCNMaterialProperty(contents: Assets.getGreyImg());
	}
	
	static func getBlack() -> SCNMaterialProperty{
		return SCNMaterialProperty(contents: Assets.getBlackImg());
	}
	
	static func getWhiteImg() -> UIImage{
		return ImageUtils.getImageWithColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 255), size: CGSizeMake(50, 50));
	}
	
	static func getGreyImg() -> UIImage{
		return ImageUtils.getImageWithColor(UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 255), size: CGSizeMake(50, 50));
	}
	
	static func getBlackImg() -> UIImage{
		return ImageUtils.getImageWithColor(UIColor(red: 0, green: 0, blue: 0, alpha: 255), size: CGSizeMake(50, 50));
	}
	
	static func getSoilImage() -> UIImage{
		let imgPath = NSBundle.mainBundle().pathForResource("soil", ofType: "jpg");
		return UIImage(contentsOfFile: imgPath!)!;
	}

}

